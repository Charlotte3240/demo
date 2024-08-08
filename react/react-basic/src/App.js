import React, {useCallback, useEffect} from "react";
import ChartsView from "./ChartsView";
function App() {
    const [data , setData] = React.useState(null);
    const transformApplicationName = useCallback((appCode) => {
        switch (appCode) {
            case "webchat_dxld":
                return "电销联动";
            case "webchat_laokedxld":
                return "老客电销联动";
            case "webchat_high_act":
                return "高价值-活跃户";
            case "webchat_grow_act":
                return "成长型-活跃户";
            case "webchat_new_act":
                return "23年后新客-活跃户";
            case "webchat_by_new_act":
                return "百应-23年后新客-活跃户"
            case "webchat_94_new_act":
                return "九四-23年后新客-活跃户"
            default:
                return "ignore";
        }
    }, []);

    const refactorDataToShow = useCallback((data) => {
        data = data['yesterday'];
        console.log('过滤前')
        console.info(data);
        data = Array.from(data).filter(e => transformApplicationName(e.appCode) !== "ignore");
        console.log('过滤后');
        console.info(data);
        return data && data.map(item => {
            return <ChartsView key={item.appCode} data={item} />;
        });
    }, [transformApplicationName]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const syncRes = await syncPlatformDeviceGroup();
                console.log(syncRes);
                let dashboard_data = await getDashboardInfo();
                const data = refactorDataToShow(dashboard_data);
                setData(data);
            } catch (e) {
                console.error(e);
            }
        };
        fetchData();
    }, [refactorDataToShow]); // 将 refactorDataToShow 添加到依赖数组中


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



    return (
        <div className="App">
            <div>
                <h1 style={{textAlign:"center"}}>昨日数据</h1>
                <div style={{display: "flex"}}>
                    {
                        data
                    }
                </div>
            </div>
        </div>
    )
}

export default App;
