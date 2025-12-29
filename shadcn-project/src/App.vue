<script setup>
import { ref, onMounted } from 'vue';
import * as echarts from 'echarts';

const v1Charts = ref([]);
const v2Charts = ref([]);

const v1Data = ref([
  {
    deviceCount: 40,
    total: 24606,
    pending: 16202,
    appCode: 'webchat_new_act',
    remainingCapacity: 0.6375
  },
  {
    deviceCount: 7,
    total: 4,
    pending: 0,
    appCode: 'webchat_new_sil',
    remainingCapacity: 0.6458333333333334
  },
  {
    deviceCount: 137,
    total: 1352,
    pending: 4,
    appCode: 'webchat_laokedxld',
    remainingCapacity: 0.36213235294117646
  },
  {
    deviceCount: 75,
    total: 429,
    pending: 0,
    appCode: 'webchat_dxld',
    remainingCapacity: 0.6789906103286385
  },
  {
    deviceCount: 84,
    total: 786,
    pending: 3,
    appCode: 'webchat_dxld_zsh_act',
    remainingCapacity: 0.4397590361445783
  },
  {
    deviceCount: 55,
    total: 41207,
    pending: 33133,
    appCode: 'webchat_high_act',
    remainingCapacity: 0.4242424242424242
  },
  {
    deviceCount: 41,
    total: 24524,
    pending: 19626,
    appCode: 'webchat_grow_act',
    remainingCapacity: 0.4135416666666667
  }
]);

const v2Data = ref([
  {
    deviceCount: 9,
    total: 3018,
    pending: 0,
    appCode: 'webchat_high_sil',
    remainingCapacity: 0.8511904761904762
  },
  {
    deviceCount: 14,
    total: 2951,
    pending: 0,
    appCode: 'webchat_grow_sil',
    remainingCapacity: 0.8173076923076923
  }
]);

const initChart = (el, data) => {
  const chart = echarts.init(el);
  const progress = Math.floor((data.total - data.pending) / data.total * 100);
  const options = {
    grid: {
      top: '50px',
      left: '10px',
      right: '10px',
      bottom: '10px',
      containLabel: true
    },
    title: {
      show: true,
      text: `${data.appCode}(${data.deviceCount}) ${progress}%`,
      subtext: `全部:${data.total}, 待播:${data.pending}${data.remainingCapacity !== -1 ? `, 剩余能力${(data.remainingCapacity*100).toFixed(2)}%` : ''}`,
      left: 'center',
      textStyle: {
        fontSize: 18
      },
      subtextStyle: {
        fontSize: 15
      }
    },
    series: [
      {
        type: 'pie',
        radius: ['50%', '70%'],
        avoidLabelOverlap: false,
        label: {
          show: false
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
          {value: progress, name: '', itemStyle: {color: '#65C466'}},
          {value: 100 - progress, name: '', itemStyle: {color: '#E6E6E6'}}
        ]
      }
    ]
  };

  chart.setOption(options);
};

onMounted(() => {
  // 初始化图表
  const initCharts = () => {
    v1Data.value.forEach((data, index) => {
      if (v1Charts.value[index]) {
        initChart(v1Charts.value[index], data);
      }
    });

    v2Data.value.forEach((data, index) => {
      if (v2Charts.value[index]) {
        initChart(v2Charts.value[index], data);
      }
    });
  };

  // 首次初始化
  initCharts();

  // 自动刷新数据
  setInterval(initCharts, 30000); // 每30秒刷新一次
});
</script>

<template>
  <div class="dashboard dark">
    <section class="section">
      <h2 class="title">企微1.0</h2>
      <div class="grid-container">
        <div v-for="(item, index) in v1Data" :key="item.appCode" class="chart-container" style="width: 280px; display: flex; align-items: center; justify-content: center">
          <div class="v1-chart" :ref="el => v1Charts[index] = el" style="width: 100%"></div>
        </div>
      </div>
    </section>

    <section class="section">
      <h2 class="title">企微2.0</h2>
      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>应用代码</th>
              <th>设备数量</th>
              <th>总量</th>
              <th>剩余容量</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in v2Data" :key="item.appCode">
              <td>{{ item.appCode }}</td>
              <td>{{ item.deviceCount }}</td>
              <td>{{ item.total }}</td>
              <td>{{ Math.round(item.remainingCapacity * 100) }}%</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </div>
</template>

<style scoped>
.dashboard.dark {
  background-color: #ffffff;
  color: #333333;
  min-height: 100vh;
  padding: 2rem;
}

.section {
  margin-bottom: 2rem;
}

.title {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #333333;
}

.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1rem;
  padding: 1rem;
}

.table-container {
  overflow-x: auto;
  max-width: 800px;
  margin: 0 auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  background-color: #ffffff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.data-table th,
.data-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e2e8f0;
}

.data-table th {
  background-color: #f7fafc;
  font-weight: 600;
  color: #4a5568;
}

.data-table tr:hover {
  background-color: #f7fafc;
}
</style>
