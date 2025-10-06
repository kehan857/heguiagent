<template>
  <div class="knowledge-library">
    <!-- 顶部导航 -->
    <Header />
    
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="container">
        <div class="header-content">
          <div class="title-section">
            <h1 class="page-title">知识库</h1>
            <p class="page-subtitle">行业标准与知识体系，提供全面的技术文档和标准规范</p>
          </div>
          
          <div class="search-section">
            <a-input-search
              v-model:value="searchValue"
              placeholder="输入关键词搜索知识文档，如：国家标准、行业标准、技术规范..."
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

    <!-- 分类导航 -->
    <div class="category-section">
      <div class="container">
        <div class="category-tabs">
          <a-tabs v-model:activeKey="selectedCategory" @change="handleCategoryChange">
            <a-tab-pane key="all" tab="全部">
              <div class="category-grid">
                <div 
                  v-for="category in allCategories" 
                  :key="category.key"
                  class="category-card"
                  @click="selectCategory(category.key)"
                >
                  <div class="category-icon">
                    <component :is="category.icon" />
                  </div>
                  <h3>{{ category.name }}</h3>
                  <p>{{ category.description }}</p>
                  <span class="knowledge-count">{{ category.count }}个文档</span>
                </div>
              </div>
            </a-tab-pane>
            
            <a-tab-pane 
              v-for="category in categories" 
              :key="category.key" 
              :tab="category.name"
            >
              <div class="subcategory-grid">
                <div 
                  v-for="subcategory in category.children" 
                  :key="subcategory.key"
                  class="subcategory-card"
                  @click="selectSubCategory(subcategory.key)"
                >
                  <h4>{{ subcategory.name }}</h4>
                  <p>{{ subcategory.description }}</p>
                  <span class="knowledge-count">{{ subcategory.count }}个文档</span>
                </div>
              </div>
            </a-tab-pane>
          </a-tabs>
        </div>
      </div>
    </div>

    <!-- 筛选条件区域 -->
    <div class="filters-section">
      <div class="container">
        <div class="filters-container">
          <div class="filter-row">
            <div class="filter-group">
              <label>文档类型</label>
              <a-select v-model:value="filters.docType" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="national-standard">国家标准</a-select-option>
                <a-select-option value="industry-standard">行业标准</a-select-option>
                <a-select-option value="technical-spec">技术规范</a-select-option>
                <a-select-option value="white-paper">白皮书</a-select-option>
                <a-select-option value="research-report">研究报告</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>适用行业</label>
              <a-select v-model:value="filters.industry" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="manufacturing">制造业</a-select-option>
                <a-select-option value="energy">能源</a-select-option>
                <a-select-option value="chemical">化工</a-select-option>
                <a-select-option value="automotive">汽车</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>发布时间</label>
              <a-range-picker v-model:value="filters.dateRange" style="width: 200px" />
            </div>
            
            <div class="filter-group">
              <label>文档状态</label>
              <a-select v-model:value="filters.status" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="current">现行</a-select-option>
                <a-select-option value="draft">草案</a-select-option>
                <a-select-option value="obsolete">废止</a-select-option>
              </a-select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 数据统计和操作区域 -->
    <div class="data-section">
      <div class="container">
        <div class="data-header">
          <div class="data-info">
            <span class="data-count">共有符合条件的知识文档 <strong>{{ totalCount }}</strong> 个</span>
          </div>
          <div class="data-actions">
            <a-button type="primary" @click="exportData">
              <DownloadOutlined />
              导出
            </a-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 知识文档列表 -->
    <div class="knowledge-list">
      <div class="container">
        <div class="list-container">
          <div 
            v-for="knowledge in knowledgeList" 
            :key="knowledge.id"
            class="knowledge-item"
            @click="viewKnowledgeDetail(knowledge)"
          >
            <!-- 左侧文档图标 -->
            <div class="knowledge-icon">
              <component :is="knowledge.icon" />
            </div>
            
            <!-- 右侧文档信息 -->
            <div class="knowledge-info">
              <!-- 文档标题和标签 -->
              <div class="knowledge-header">
                <h3 class="knowledge-title">{{ knowledge.title }}</h3>
                <div class="knowledge-tags">
                  <a-tag 
                    v-for="tag in knowledge.tags" 
                    :key="tag"
                    :color="getTagColor(tag)"
                  >
                    {{ tag }}
                  </a-tag>
                </div>
              </div>
              
              <!-- 文档基本信息 -->
              <div class="knowledge-basic-info">
                <div class="info-row">
                  <span class="info-label">文档类型：</span>
                  <span class="info-value">{{ knowledge.type }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">标准编号：</span>
                  <span class="info-value">{{ knowledge.standardNumber }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">发布机构：</span>
                  <span class="info-value">{{ knowledge.publisher }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">发布日期：</span>
                  <span class="info-value">{{ knowledge.publishDate }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">实施日期：</span>
                  <span class="info-value">{{ knowledge.effectiveDate }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">文档状态：</span>
                  <span class="info-value">
                    <a-tag :color="getStatusColor(knowledge.status)">
                      {{ knowledge.status }}
                    </a-tag>
                  </span>
                </div>
              </div>
              
              <!-- 文档摘要 -->
              <div class="knowledge-abstract">
                <h4>文档摘要</h4>
                <p>{{ knowledge.abstract }}</p>
              </div>
              
              <!-- 适用范围 -->
              <div class="knowledge-scope">
                <h4>适用范围</h4>
                <div class="scope-tags">
                  <a-tag 
                    v-for="scope in knowledge.scope" 
                    :key="scope"
                    class="scope-tag"
                  >
                    {{ scope }}
                  </a-tag>
                </div>
              </div>
              
              <!-- 相关文档 -->
              <div class="knowledge-related">
                <h4>相关文档</h4>
                <div class="related-list">
                  <a 
                    v-for="related in knowledge.related" 
                    :key="related.id"
                    class="related-item"
                    @click.stop="viewRelatedDocument(related)"
                  >
                    {{ related.title }}
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 分页 -->
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
  BookOutlined,
  FileTextOutlined,
  SafetyOutlined,
  ToolOutlined,
  BulbOutlined,
  DatabaseOutlined,
  CloudOutlined,
  SettingOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

// 搜索和筛选数据
const searchValue = ref('')
const selectedCategory = ref('all')
const selectedSubCategory = ref('')
const filters = reactive({
  docType: 'all',
  industry: 'all',
  dateRange: [],
  status: 'all'
})

// 分页数据
const currentPage = ref(1)
const pageSize = ref(10)
const totalCount = ref(15820)

// 分类数据
const allCategories = [
  {
    key: 'standards',
    name: '标准规范',
    description: '国家标准、行业标准、技术规范',
    icon: FileTextOutlined,
    count: 8250
  },
  {
    key: 'safety',
    name: '安全防护',
    description: '安全标准、防护规范、应急预案',
    icon: SafetyOutlined,
    count: 3420
  },
  {
    key: 'technology',
    name: '技术文档',
    description: '技术规范、操作手册、维护指南',
    icon: ToolOutlined,
    count: 2890
  },
  {
    key: 'research',
    name: '研究报告',
    description: '行业报告、白皮书、调研报告',
    icon: BookOutlined,
    count: 1260
  }
]

const categories = [
  {
    key: 'standards',
    name: '标准规范',
    children: [
      {
        key: 'national-standards',
        name: '国家标准',
        description: 'GB系列国家标准',
        count: 4200
      },
      {
        key: 'industry-standards',
        name: '行业标准',
        description: '各行业专业标准',
        count: 2800
      },
      {
        key: 'technical-specs',
        name: '技术规范',
        description: '技术实施规范',
        count: 1250
      }
    ]
  },
  {
    key: 'safety',
    name: '安全防护',
    children: [
      {
        key: 'safety-standards',
        name: '安全标准',
        description: '安全生产标准',
        count: 1800
      },
      {
        key: 'protection-specs',
        name: '防护规范',
        description: '防护设备规范',
        count: 1200
      },
      {
        key: 'emergency-plans',
        name: '应急预案',
        description: '应急处理预案',
        count: 420
      }
    ]
  }
]

// 知识文档列表数据
const knowledgeList = ref([
  {
    id: 1,
    title: 'GB 3836.1-2021 爆炸性环境 第1部分：设备 通用要求',
    icon: FileTextOutlined,
    tags: ['国家标准', '防爆设备', '安全标准'],
    type: '国家标准',
    standardNumber: 'GB 3836.1-2021',
    publisher: '国家市场监督管理总局',
    publishDate: '2021-12-01',
    effectiveDate: '2022-06-01',
    status: '现行',
    abstract: '本标准规定了爆炸性环境中电气设备的通用要求，包括设备分类、温度组别、防护等级等基本要求，适用于所有在爆炸性环境中使用的电气设备。',
    scope: ['防爆电气设备', '爆炸性环境', '安全防护', '设备认证'],
    related: [
      { id: 1, title: 'GB 3836.2-2021 爆炸性环境 第2部分：隔爆型设备' },
      { id: 2, title: 'GB 3836.3-2021 爆炸性环境 第3部分：增安型设备' }
    ]
  },
  {
    id: 2,
    title: 'AQ 3009-2007 危险场所电气防爆安全规范',
    icon: SafetyOutlined,
    tags: ['行业标准', '危险场所', '电气防爆'],
    type: '行业标准',
    standardNumber: 'AQ 3009-2007',
    publisher: '国家安全生产监督管理总局',
    publishDate: '2007-12-01',
    effectiveDate: '2008-06-01',
    status: '现行',
    abstract: '本规范规定了危险场所电气防爆的基本要求、设备选型、安装维护等安全技术要求，适用于石油、化工、煤炭等危险场所的电气防爆工作。',
    scope: ['危险场所', '电气防爆', '安全规范', '设备选型'],
    related: [
      { id: 1, title: 'AQ 3008-2007 危险场所电气防爆安全评价' },
      { id: 2, title: 'GB 50058-2014 爆炸危险环境电力装置设计规范' }
    ]
  }
])

// 方法
const handleSearch = (value) => {
  console.log('搜索知识文档:', value)
}

const selectCategory = (categoryKey) => {
  selectedCategory.value = categoryKey
  selectedSubCategory.value = ''
}

const selectSubCategory = (subCategoryKey) => {
  selectedSubCategory.value = subCategoryKey
}

const handleCategoryChange = (key) => {
  selectedCategory.value = key
  selectedSubCategory.value = ''
}

const exportData = () => {
  console.log('导出知识文档')
}

const viewKnowledgeDetail = (knowledge) => {
  console.log('查看知识文档详情:', knowledge)
}

const viewRelatedDocument = (related) => {
  console.log('查看相关文档:', related)
}

const getTagColor = (tag) => {
  const colorMap = {
    '国家标准': 'red',
    '行业标准': 'blue',
    '技术规范': 'green',
    '防爆设备': 'orange',
    '安全标准': 'purple',
    '危险场所': 'volcano',
    '电气防爆': 'cyan'
  }
  return colorMap[tag] || 'default'
}

const getStatusColor = (status) => {
  const colorMap = {
    '现行': 'green',
    '草案': 'orange',
    '废止': 'red'
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
  console.log('知识库页面加载完成')
})
</script>

<style lang="scss" scoped>
.knowledge-library {
  min-height: 100vh;
  background: $bg-secondary;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 $spacing-lg;
}

// 页面头部
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

// 分类区域
.category-section {
  background: $bg-primary;
  padding: $spacing-lg 0;
  border-bottom: 1px solid $border-light;
}

.category-tabs {
  :deep(.ant-tabs-content-holder) {
    padding-top: $spacing-lg;
  }
}

.category-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: $spacing-lg;
}

.category-card {
  background: $bg-secondary;
  border-radius: $border-radius-lg;
  padding: $spacing-lg;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid transparent;
  
  &:hover {
    border-color: $primary-color;
    transform: translateY(-2px);
    box-shadow: $box-shadow-hover;
  }
  
  .category-icon {
    width: 60px;
    height: 60px;
    background: $bg-gradient;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto $spacing-md;
    color: $text-white;
    font-size: 24px;
  }
  
  h3 {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  p {
    color: $text-secondary;
    font-size: $font-size-sm;
    margin-bottom: $spacing-md;
  }
  
  .knowledge-count {
    color: $primary-color;
    font-weight: 600;
    font-size: $font-size-sm;
  }
}

.subcategory-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: $spacing-md;
}

.subcategory-card {
  background: $bg-secondary;
  border-radius: $border-radius;
  padding: $spacing-md;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid $border-light;
  
  &:hover {
    border-color: $primary-color;
    background: $bg-primary;
  }
  
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-xs;
  }
  
  p {
    color: $text-secondary;
    font-size: $font-size-sm;
    margin-bottom: $spacing-sm;
  }
  
  .knowledge-count {
    color: $primary-color;
    font-weight: 600;
    font-size: $font-size-xs;
  }
}

// 筛选条件区域
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

// 数据统计区域
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

// 知识文档列表
.knowledge-list {
  padding: $spacing-lg 0;
}

.list-container {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
}

.knowledge-item {
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

.knowledge-icon {
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

.knowledge-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: $spacing-md;
}

.knowledge-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: $spacing-md;
  
  .knowledge-title {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
    flex: 1;
  }
  
  .knowledge-tags {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
}

.knowledge-basic-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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

.knowledge-abstract {
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

.knowledge-scope {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .scope-tags {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
  
  .scope-tag {
    margin: 0;
  }
}

.knowledge-related {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .related-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .related-item {
    color: $primary-color;
    text-decoration: none;
    font-size: $font-size-sm;
    
    &:hover {
      text-decoration: underline;
    }
  }
}

// 分页
.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: $spacing-xl;
  padding: $spacing-lg 0;
}

// 响应式设计
@media (max-width: $breakpoint-lg) {
  .header-content {
    flex-direction: column;
    text-align: center;
    gap: $spacing-lg;
  }
  
  .search-section {
    max-width: 100%;
  }
  
  .category-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .knowledge-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .knowledge-basic-info {
    grid-template-columns: 1fr;
  }
}

@media (max-width: $breakpoint-md) {
  .page-title {
    font-size: $font-size-xxl !important;
  }
  
  .category-grid {
    grid-template-columns: 1fr;
  }
  
  .subcategory-grid {
    grid-template-columns: 1fr;
  }
  
  .filter-row {
    flex-direction: column;
    gap: $spacing-md;
  }
  
  .knowledge-item {
    flex-direction: column;
  }
  
  .knowledge-icon {
    align-self: center;
  }
}
</style>

