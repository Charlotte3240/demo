import React, {useEffect} from "react";
import ChartsView from "./ChartsView";
function App() {
    const [data , setData] = React.useState(null);
    useEffect(() => {
        const fetchData = async () => {
            try{
                const syncRes = await syncPlatformDeviceGroup();
                console.log(syncRes)
                const data = await getDashboardInfo();
                console.log(data)
                setData(data)
            }catch (e){
                console.error(e);
            }
        }
        fetchData()

    }, []); // 空数组作为第二个参数，表示只在组件挂载时执行一次

    async function syncPlatformDeviceGroup() {
        try {
            const response = await fetch('http://localhost:9091/rpa/syncPlatformDeviceGroup');
            const data = await response.json();
            return data;
        } catch (error) {
            console.error('Error fetching device group data:', error); // 处理错误
            throw error; // 抛出错误，终止后续执行
        }
    }

    async function getDashboardInfo(){
        try {
            const response = await fetch('http://localhost:9091/rpa/pdt/dashboardInfo')
            const data = await response.json();
            return data;
        }catch (error){
            console.error('Error fetching dashboard data:', error);
        }

    }

    function transformApplicationName(appCode) {
        switch (appCode) {
            case "webchat":
                return "企业微信"
            case "webchat_yjq":
                return "已结清"
            case "webchat_zd":
                return "老客在贷"
            case "webchat_dxld":
                return "电销联动"
            case "webchat_laokedxld":
                return "老客电销联动"
            case "webchat_dxqw":
                return "电销企微融合销售"
            default:
                return "未知业务类型"
        }
    }
    return (
        <div className="App">
            <div>
                <h1 style={{textAlign:"center"}}>昨日数据</h1>
                <div style={{display: "flex"}}>
                    {
                        data && Array.from(data['yesterday']).map(item => {
                            item.appCode = transformApplicationName(item.appCode);
                            return <ChartsView key={item.appCode} data={item}/>
                        })
                    }
                </div>
            </div>
        </div>
    )
}

export default App;
