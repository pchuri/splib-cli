import asyncio
import aiohttp
from bs4 import BeautifulSoup
import argparse
import json
from urllib.parse import urlparse
from contextlib import asynccontextmanager

LOGIN_URL = "https://splib.or.kr/intro/program/memberLoginProc.do"
INDEX_URL = "https://splib.or.kr/intro/index.do"
LOAN_URL = "https://splib.or.kr/intro/program/mypage/loanStatusList.do"
DOORAE_URL = "https://splib.or.kr/intro/program/mypage/dooraeLillStatusList.do"
CT = "application/x-www-form-urlencoded"

LOAN_PATH = urlparse(LOAN_URL).path
DOORAE_PATH = urlparse(DOORAE_URL).path

async def login(userId, password):
    data = {"userId": userId, "password": password}
    headers = {"Content-Type": CT}

    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False)) as session:
        async with session.post(LOGIN_URL, data=data, headers=headers) as response:
            cookies = response.request_info.headers['Cookie']

    return cookies

@asynccontextmanager
async def create_session(headers):
    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False), headers=headers) as session:
        yield session

async def fetch(url, session):
    async with session.get(url) as response:
        return await response.text()

def parse_index_content(content):
    soup = BeautifulSoup(content, 'html.parser')
    barcode_info_div = soup.find('div', {'class': 'barcodeInfo'})
    name = barcode_info_div.contents[0].strip()

    loan_status_link = soup.find('a', href=LOAN_PATH)
    loan_status_span = loan_status_link.find('span')
    num_loans = int(loan_status_span.text.strip())

    doorae_status_link = soup.find('a', href=DOORAE_PATH)
    doorae_status_span = doorae_status_link.find('span')
    num_doorae = int(doorae_status_span.text.strip())

    return {"name": name, "num_loans": num_loans, "num_doorae": num_doorae}

def parse_loan_status(content):
    soup = BeautifulSoup(content, 'html.parser')
    book_titles = []
    library_names = []
    loan_dates = []
    due_dates = []

    for info_box in soup.find_all('div', class_='infoBox'):
        title_div = info_box.find('div', class_='title')
        library_div = info_box.find('div', class_='info').find('span').find('strong')
        date_info = info_box.find_all('div', class_='info')[1].find_all('span')

        if title_div and library_div and date_info and len(date_info) == 2:
            book_titles.append(title_div.get_text(strip=True))
            library_names.append(library_div.get_text(strip=True))
            loan_dates.append(date_info[0].get_text(strip=True).replace('대출일 : ', ''))
            due_dates.append(date_info[1].get_text(strip=True).replace('반납예정일 : ', ''))

    return {
        "book_titles": book_titles,
        "library_names": library_names,
        "loan_dates": loan_dates,
        "due_dates": due_dates
    }

async def login_and_fetch_data(userId, password):
    cookies = await login(userId, password)
    headers = {"Cookie": cookies}

    async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=False), headers=headers) as session:
        index_content = await fetch(INDEX_URL, session)
        index_data = parse_index_content(index_content)

        loan_status_content = await fetch(LOAN_URL, session)
        loan_data = parse_loan_status(loan_status_content)

    return {
        "user_info": index_data,
        "loan_info": loan_data
    }

def main(userId, password):
    result = asyncio.run(login_and_fetch_data(userId, password))
    print(json.dumps(result, ensure_ascii=False, indent=4))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Library Account Information CLI Tool")
    parser.add_argument("userId", type=str, help="User ID")
    parser.add_argument("password", type=str, help="Password")
    argsa = parser.parse_args()
    main(args.userId, args.password)