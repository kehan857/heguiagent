<template>
  <div class="industry-chain-library">
    <Header />
    
    <div class="page-header">
      <div class="container">
        <div class="header-content">
          <div class="title-section">
            <h1 class="page-title">产业链库</h1>
            <p class="page-subtitle">产业链关系图谱，展示上下游企业关系和产业生态</p>
          </div>
          
          <div class="search-section">
            <a-input-search
              v-model:value="searchValue"
              placeholder="输入关键词搜索产业链，如：行业名称、企业名称、产品名称..."
              size="large"
              class="main-search"
              @search="handleSearch"
            >
              <template #enterButton>
                <a-button type="primary" size="large">
                  <SearchOutlined />
                  搜索
                </a-button>
              </template>
            </a-input-search>
          </div>
        </div>
      </div>
    </div>

    <div class="filters-section">
      <div class="container">
        <div class="filters-container">
          <div class="filter-row">
            <div class="filter-group">
              <label>产业链类型</label>
              <a-select v-model:value="filters.chainType" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="manufacturing">制造业</a-select-option>
                <a-select-option value="energy">能源</a-select-option>
                <a-select-option value="chemical">化工</a-select-option>
                <a-select-option value="automotive">汽车</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>产业链环节</label>
              <a-select v-model:value="filters.chainLink" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="upstream">上游</a-select-option>
                <a-select-option value="midstream">中游</a-select-option>
                <a-select-option value="downstream">下游</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>企业规模</label>
              <a-select v-model:value="filters.companySize" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="large">大型企业</a-select-option>
                <a-select-option value="medium">中型企业</a-select-option>
                <a-select-option value="small">小型企业</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>所在地区</label>
              <a-cascader
                v-model:value="filters.region"
                :options="regionOptions"
                placeholder="请选择地区"
                style="width: 150px"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="data-section">
      <div class="container">
        <div class="data-header">
          <div class="data-info">
            <span class="data-count">共有符合条件的产业链 <strong>{{ totalCount }}</strong> 条</span>
          </div>
          <div class="data-actions">
            <a-button type="primary" @click="exportData">
              <DownloadOutlined />
              导出
            </a-button>
            <a-button @click="showChainMap">
              <NodeIndexOutlined />
              产业链图谱
            </a-button>
          </div>
        </div>
      </div>
    </div>

    <div class="chain-list">
      <div class="container">
        <div class="list-container">
          <div 
            v-for="chain in chainList" 
            :key="chain.id"
            class="chain-item"
            @click="viewChainDetail(chain)"
          >
            <div class="chain-icon">
              <NodeIndexOutlined />
            </div>
            
            <div class="chain-info">
              <div class="chain-header">
                <h3 class="chain-name">{{ chain.name }}</h3>
                <div class="chain-tags">
                  <a-tag 
                    v-for="tag in chain.tags" 
                    :key="tag"
                    :color="getTagColor(tag)"
                  >
                    {{ tag }}
                  </a-tag>
                </div>
              </div>
              
              <div class="chain-basic-info">
                <div class="info-row">
                  <span class="info-label">产业链类型：</span>
                  <span class="info-value">{{ chain.type }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">主要产品：</span>
                  <span class="info-value">{{ chain.mainProduct }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">企业数量：</span>
                  <span class="info-value">{{ chain.companyCount }}家</span>
                </div>
                <div class="info-row">
                  <span class="info-label">市场规模：</span>
                  <span class="info-value">{{ chain.marketSize }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">主要地区：</span>
                  <span class="info-value">{{ chain.mainRegion }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">发展水平：</span>
                  <span class="info-value">{{ chain.developmentLevel }}</span>
                </div>
              </div>
              
              <div class="chain-description">
                <h4>产业链概述</h4>
                <p>{{ chain.description }}</p>
              </div>
              
              <div class="chain-structure">
                <h4>产业链结构</h4>
                <div class="structure-sections">
                  <div class="structure-section">
                    <h5>上游企业</h5>
                    <div class="company-list">
                      <a-tag 
                        v-for="company in chain.upstreamCompanies" 
                        :key="company"
                        color="blue"
                        class="company-tag"
                      >
                        {{ company }}
                      </a-tag>
                    </div>
                  </div>
                  <div class="structure-section">
                    <h5>中游企业</h5>
                    <div class="company-list">
                      <a-tag 
                        v-for="company in chain.midstreamCompanies" 
                        :key="company"
                        color="green"
                        class="company-tag"
                      >
                        {{ company }}
                      </a-tag>
                    </div>
                  </div>
                  <div class="structure-section">
                    <h5>下游企业</h5>
                    <div class="company-list">
                      <a-tag 
                        v-for="company in chain.downstreamCompanies" 
                        :key="company"
                        color="orange"
                        class="company-tag"
                      >
                        {{ company }}
                      </a-tag>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="chain-trends">
                <h4>发展趋势</h4>
                <div class="trends-list">
                  <div 
                    v-for="trend in chain.trends" 
                    :key="trend.id"
                    class="trend-item"
                  >
                    <span class="trend-type">{{ trend.type }}：</span>
                    <span class="trend-content">{{ trend.content }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="pagination-container">
          <a-pagination
            v-model:current="currentPage"
            v-model:page-size="pageSize"
            :total="totalCount"
            :show-size-changer="true"
            :show-quick-jumper="true"
            :show-total="(total, range) => `第 ${range[0]}-${range[1]} 条，共 ${total} 条`"
            @change="handlePageChange"
            @show-size-change="handlePageSizeChange"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Header from '@/components/Header.vue'
import {
  SearchOutlined,
  DownloadOutlined,
  NodeIndexOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

const searchValue = ref('')
const filters = reactive({
  chainType: 'all',
  chainLink: 'all',
  companySize: 'all',
  region: []
})

const currentPage = ref(1)
const pageSize = ref(10)
const totalCount = ref(1250)

const regionOptions = [
  {
    value: 'beijing',
    label: '北京',
    children: [
      { value: 'beijing-city', label: '北京市' }
    ]
  },
  {
    value: 'shanghai',
    label: '上海',
    children: [
      { value: 'shanghai-city', label: '上海市' }
    ]
  }
]

const chainList = ref([
  {
    id: 1,
    name: '防爆设备产业链',
    tags: ['制造业', '安全防护', '工业设备'],
    type: '制造业',
    mainProduct: '防爆电气设备',
    companyCount: 1250,
    marketSize: '500亿元',
    mainRegion: '长三角、珠三角',
    developmentLevel: '成熟',
    description: '防爆设备产业链涵盖了从原材料供应、设备制造到应用服务的完整链条，是工业安全领域的重要组成部分。',
    upstreamCompanies: ['钢铁企业', '有色金属企业', '电子元器件企业', '塑料化工企业'],
    midstreamCompanies: ['防爆设备制造商', '控制系统集成商', '检测认证机构'],
    downstreamCompanies: ['石油化工企业', '煤矿企业', '制药企业', '食品加工企业'],
    trends: [
      { id: 1, type: '技术趋势', content: '智能化、数字化防爆设备成为发展方向' },
      { id: 2, type: '市场趋势', content: '新兴行业需求增长，传统行业升级改造' },
      { id: 3, type: '政策趋势', content: '安全标准不断提高，监管日趋严格' }
    ]
  }
])

const handleSearch = (value) => {
  console.log('搜索产业链:', value)
}

const exportData = () => {
  console.log('导出产业链数据')
}

const showChainMap = () => {
  console.log('显示产业链图谱')
}

const viewChainDetail = (chain) => {
  console.log('查看产业链详情:', chain)
}

const getTagColor = (tag) => {
  const colorMap = {
    '制造业': 'blue',
    '安全防护': 'red',
    '工业设备': 'green',
    '能源': 'orange',
    '化工': 'purple'
  }
  return colorMap[tag] || 'default'
}

const handlePageChange = (page, size) => {
  currentPage.value = page
  pageSize.value = size
}

const handlePageSizeChange = (current, size) => {
  currentPage.value = current
  pageSize.value = size
}

onMounted(() => {
  console.log('产业链库页面加载完成')
})
</script>

<style lang="scss" scoped>
.industry-chain-library {
  min-height: 100vh;
  background: $bg-secondary;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 $spacing-lg;
}

.page-header {
  background: $bg-gradient;
  color: $text-white;
  padding: $spacing-xxl 0;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: $spacing-xl;
}

.title-section {
  .page-title {
    font-size: $font-size-xxxl;
    font-weight: 700;
    margin-bottom: $spacing-sm;
  }
  
  .page-subtitle {
    font-size: $font-size-md;
    opacity: 0.9;
  }
}

.search-section {
  flex: 1;
  max-width: 600px;
  
  .main-search {
    :deep(.ant-input) {
      height: 48px;
      font-size: $font-size-md;
      border-radius: $border-radius-lg;
    }
    
    :deep(.ant-btn) {
      height: 48px;
      border-radius: $border-radius-lg;
    }
  }
}

.filters-section {
  background: $bg-primary;
  border-bottom: 1px solid $border-light;
  padding: $spacing-lg 0;
}

.filters-container {
  .filter-row {
    display: flex;
    gap: $spacing-lg;
    flex-wrap: wrap;
  }
  
  .filter-group {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
    
    label {
      font-size: $font-size-sm;
      color: $text-secondary;
      font-weight: 500;
    }
  }
}

.data-section {
  background: $bg-primary;
  padding: $spacing-md 0;
  border-bottom: 1px solid $border-light;
}

.data-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.data-info {
  .data-count {
    font-size: $font-size-md;
    color: $text-primary;
    
    strong {
      color: $primary-color;
      font-weight: 600;
    }
  }
}

.data-actions {
  display: flex;
  gap: $spacing-md;
}

.chain-list {
  padding: $spacing-lg 0;
}

.list-container {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
}

.chain-item {
  background: $bg-primary;
  border-radius: $border-radius-lg;
  padding: $spacing-lg;
  box-shadow: $box-shadow;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  gap: $spacing-lg;
  
  &:hover {
    box-shadow: $box-shadow-hover;
    transform: translateY(-2px);
  }
}

.chain-icon {
  flex-shrink: 0;
  width: 60px;
  height: 60px;
  background: $bg-gradient;
  border-radius: $border-radius;
  display: flex;
  align-items: center;
  justify-content: center;
  color: $text-white;
  font-size: 24px;
}

.chain-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: $spacing-md;
}

.chain-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: $spacing-md;
  
  .chain-name {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
    flex: 1;
  }
  
  .chain-tags {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
}

.chain-basic-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: $spacing-sm;
  
  .info-row {
    display: flex;
    align-items: center;
    gap: $spacing-xs;
    
    .info-label {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 80px;
    }
    
    .info-value {
      font-size: $font-size-sm;
      color: $text-primary;
    }
  }
}

.chain-description {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  p {
    color: $text-secondary;
    line-height: 1.6;
  }
}

.chain-structure {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-md;
  }
  
  .structure-sections {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: $spacing-md;
  }
  
  .structure-section {
    h5 {
      font-size: $font-size-sm;
      font-weight: 600;
      color: $text-primary;
      margin-bottom: $spacing-sm;
    }
    
    .company-list {
      display: flex;
      flex-wrap: wrap;
      gap: $spacing-xs;
    }
    
    .company-tag {
      margin: 0;
      font-size: $font-size-xs;
    }
  }
}

.chain-trends {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .trends-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .trend-item {
    display: flex;
    gap: $spacing-xs;
    
    .trend-type {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 80px;
    }
    
    .trend-content {
      font-size: $font-size-sm;
      color: $text-primary;
    }
  }
}

.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: $spacing-xl;
  padding: $spacing-lg 0;
}

@media (max-width: $breakpoint-lg) {
  .header-content {
    flex-direction: column;
    text-align: center;
    gap: $spacing-lg;
  }
  
  .search-section {
    max-width: 100%;
  }
  
  .chain-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .chain-basic-info {
    grid-template-columns: 1fr;
  }
  
  .structure-sections {
    grid-template-columns: 1fr !important;
  }
}

@media (max-width: $breakpoint-md) {
  .page-title {
    font-size: $font-size-xxl !important;
  }
  
  .filter-row {
    flex-direction: column;
    gap: $spacing-md;
  }
  
  .chain-item {
    flex-direction: column;
  }
  
  .chain-icon {
    align-self: center;
  }
}
</style>

