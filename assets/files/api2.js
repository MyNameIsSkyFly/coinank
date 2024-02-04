const apiHost = "https://coinank.com"
const getLiqHeatMap = (params)=>{
    let {exchangeName, symbol, interval} = params
    return fetch(`${apiHost}/api/liqMap/getLiqHeatMap?exchangeName=${exchangeName}&symbol=${symbol}&interval=${interval}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );
}

const fetchKline = (params)=>{

    let {exchange, symbol, interval, side, ts, size} = params;
    let query = `exchange=${exchange}&symbol=${symbol}&interval=${interval}&side=${side}&ts=${ts}&size=${size}`
    return fetch(`${apiHost}/api/kline/list?${query}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );

}

const fetchSpotTickers = (params) =>{

    let {baseCoin} = params;
    let query = `baseCoin=${baseCoin}`
    return fetch(`${apiHost}/api/tickers/getSpotTickers?${query}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );
}

const fetchContractTickers = (params) => {
    let {baseCoin} = params;
    let query = `baseCoin=${baseCoin}`
    return fetch(`${apiHost}/api/tickers?${query}`,
        {
            method: 'GET', // 请求方法
            headers: {
                'client':"ios",
                'Content-Type': 'application/json', // 设置Content-Type为JSON
            }
        }
    );
}
