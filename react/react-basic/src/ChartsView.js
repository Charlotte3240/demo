import React from 'react';
import * as echarts from 'echarts/core';
import ReactECharts from 'echarts-for-react'

const ChartsView = ({ data }) => {
    const { total, pending, deviceCount, appCode } = data;
    let progress =Math.floor((total - pending) / total * 100)
    console.log(data)
    // 在这里定义你的 ECharts 配置项
    const option = {
        series: [
            {
                type: 'pie',
                radius: ['50%', '70%'],
                avoidLabelOverlap: false,
                label: {
                    show: false,
                },
                emphasis: {
                    label: {
                        show: false,
                        fontSize: '40',
                        fontWeight: 'bold'
                    }
                },
                labelLine: {
                    show: false
                },
                data: [
                    {value: progress, name: '',itemStyle: {color: '#65C466'}},
                    {value: 100 - progress, name: '',itemStyle: {color: '#E6E6E6'}},
                ]
            }
        ]
    };
    return (
        <div style={{width: 250}}>
            <ReactECharts echarts={echarts} option={option}/>
            <div style={{textAlign: "center", fontSize: 20, fontWeight: "bold"}}>{appCode} ({deviceCount}) {progress}%
            </div>
            <div style={{textAlign: "center", fontSize: 15}}>全部:{total},待播:{pending}</div>
        </div>
    );
};

export default ChartsView;
