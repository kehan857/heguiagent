<template>
  <div class="demand-library">
    <Header />
    
    <div class="page-header">
      <div class="container">
        <div class="header-content">
          <div class="title-section">
            <h1 class="page-title">需求库</h1>
            <p class="page-subtitle">商业需求与机会，汇聚行业采购需求和合作机会</p>
          </div>
          
          <div class="search-section">
            <a-input-search
              v-model:value="searchValue"
              placeholder="输入关键词搜索需求，如：产品名称、服务类型、采购需求..."
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
              <label>需求类型</label>
              <a-select v-model:value="filters.demandType" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="procurement">采购需求</a-select-option>
                <a-select-option value="cooperation">合作需求</a-select-option>
                <a-select-option value="service">服务需求</a-select-option>
                <a-select-option value="investment">投资需求</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>需求状态</label>
              <a-select v-model:value="filters.status" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="active">进行中</a-select-option>
                <a-select-option value="pending">待处理</a-select-option>
                <a-select-option value="completed">已完成</a-select-option>
                <a-select-option value="cancelled">已取消</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>预算范围</label>
              <a-select v-model:value="filters.budget" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="low">10万以下</a-select-option>
                <a-select-option value="medium">10-100万</a-select-option>
                <a-select-option value="high">100万以上</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>发布时间</label>
              <a-range-picker v-model:value="filters.dateRange" style="width: 200px" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="data-section">
      <div class="container">
        <div class="data-header">
          <div class="data-info">
            <span class="data-count">共有符合条件的需求 <strong>{{ totalCount }}</strong> 个</span>
          </div>
          <div class="data-actions">
            <a-button type="primary" @click="exportData">
              <DownloadOutlined />
              导出
            </a-button>
            <a-button @click="publishDemand">
              <PlusOutlined />
              发布需求
            </a-button>
          </div>
        </div>
      </div>
    </div>

    <div class="demand-list">
      <div class="container">
        <div class="list-container">
          <div 
            v-for="demand in demandList" 
            :key="demand.id"
            class="demand-item"
            @click="viewDemandDetail(demand)"
          >
            <div class="demand-icon">
              <ShoppingCartOutlined />
            </div>
            
            <div class="demand-info">
              <div class="demand-header">
                <h3 class="demand-title">{{ demand.title }}</h3>
                <div class="demand-tags">
                  <a-tag 
                    v-for="tag in demand.tags" 
                    :key="tag"
                    :color="getTagColor(tag)"
                  >
                    {{ tag }}
                  </a-tag>
                </div>
              </div>
              
              <div class="demand-basic-info">
                <div class="info-row">
                  <span class="info-label">需求类型：</span>
                  <span class="info-value">{{ demand.type }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">发布企业：</span>
                  <span class="info-value">{{ demand.company }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">预算范围：</span>
                  <span class="info-value">{{ demand.budget }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">发布时间：</span>
                  <span class="info-value">{{ demand.publishDate }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">截止时间：</span>
                  <span class="info-value">{{ demand.deadline }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">需求状态：</span>
                  <span class="info-value">
                    <a-tag :color="getStatusColor(demand.status)">
                      {{ demand.status }}
                    </a-tag>
                  </span>
                </div>
              </div>
              
              <div class="demand-description">
                <h4>需求描述</h4>
                <p>{{ demand.description }}</p>
              </div>
              
              <div class="demand-requirements">
                <h4>具体要求</h4>
                <div class="requirements-list">
                  <div 
                    v-for="requirement in demand.requirements" 
                    :key="requirement.id"
                    class="requirement-item"
                  >
                    <span class="requirement-label">{{ requirement.label }}：</span>
                    <span class="requirement-value">{{ requirement.value }}</span>
                  </div>
                </div>
              </div>
              
              <div class="demand-contact">
                <h4>联系方式</h4>
                <div class="contact-info">
                  <div class="contact-item">
                    <span class="contact-label">联系人：</span>
                    <span class="contact-value">{{ demand.contact.name }}</span>
                  </div>
                  <div class="contact-item">
                    <span class="contact-label">电话：</span>
                    <span class="contact-value">{{ demand.contact.phone }}</span>
                  </div>
                  <div class="contact-item">
                    <span class="contact-label">邮箱：</span>
                    <span class="contact-value">{{ demand.contact.email }}</span>
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
  PlusOutlined,
  ShoppingCartOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

const searchValue = ref('')
const filters = reactive({
  demandType: 'all',
  status: 'all',
  budget: 'all',
  dateRange: []
})

const currentPage = ref(1)
const pageSize = ref(10)
const totalCount = ref(3580)

const demandList = ref([
  {
    id: 1,
    title: '防爆型压力变送器采购需求',
    tags: ['采购需求', '防爆设备', '压力测量'],
    type: '采购需求',
    company: '某石油化工企业',
    budget: '50-100万',
    publishDate: '2024-01-15',
    deadline: '2024-02-15',
    status: '进行中',
    description: '我公司需要采购一批防爆型压力变送器，用于石油化工生产过程中的压力监测，要求产品符合相关防爆标准，具有高精度和稳定性。',
    requirements: [
      { id: 1, label: '防爆等级', value: 'Exd IIC T6' },
      { id: 2, label: '测量范围', value: '0-100MPa' },
      { id: 3, label: '精度要求', value: '±0.1%FS' },
      { id: 4, label: '数量', value: '100台' },
      { id: 5, label: '交付时间', value: '合同签订后30天内' }
    ],
    contact: {
      name: '张工程师',
      phone: '138-0000-0000',
      email: 'zhang@example.com'
    }
  }
])

const handleSearch = (value) => {
  console.log('搜索需求:', value)
}

const exportData = () => {
  console.log('导出需求数据')
}

const publishDemand = () => {
  console.log('发布需求')
}

const viewDemandDetail = (demand) => {
  console.log('查看需求详情:', demand)
}

const getTagColor = (tag) => {
  const colorMap = {
    '采购需求': 'blue',
    '合作需求': 'green',
    '服务需求': 'orange',
    '投资需求': 'purple',
    '防爆设备': 'red',
    '压力测量': 'cyan'
  }
  return colorMap[tag] || 'default'
}

const getStatusColor = (status) => {
  const colorMap = {
    '进行中': 'green',
    '待处理': 'orange',
    '已完成': 'blue',
    '已取消': 'red'
  }
  return colorMap[status] || 'default'
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
  console.log('需求库页面加载完成')
})
</script>

<style lang="scss" scoped>
.demand-library {
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

.demand-list {
  padding: $spacing-lg 0;
}

.list-container {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
}

.demand-item {
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

.demand-icon {
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

.demand-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: $spacing-md;
}

.demand-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: $spacing-md;
  
  .demand-title {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
    flex: 1;
  }
  
  .demand-tags {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
}

.demand-basic-info {
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

.demand-description {
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

.demand-requirements {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .requirements-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .requirement-item {
    display: flex;
    gap: $spacing-xs;
    
    .requirement-label {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 80px;
    }
    
    .requirement-value {
      font-size: $font-size-sm;
      color: $text-primary;
    }
  }
}

.demand-contact {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .contact-info {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .contact-item {
    display: flex;
    gap: $spacing-xs;
    
    .contact-label {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 60px;
    }
    
    .contact-value {
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
  
  .demand-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .demand-basic-info {
    grid-template-columns: 1fr;
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
  
  .demand-item {
    flex-direction: column;
  }
  
  .demand-icon {
    align-self: center;
  }
}
</style>

