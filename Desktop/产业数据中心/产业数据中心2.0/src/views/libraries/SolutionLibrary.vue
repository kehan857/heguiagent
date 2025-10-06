<template>
  <div class="solution-library">
    <!-- 顶部导航 -->
    <Header />
    
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="container">
        <div class="header-content">
          <div class="title-section">
            <h1 class="page-title">方案库</h1>
            <p class="page-subtitle">建立结构化的行业解决方案知识库，并利用AI赋能售前工作</p>
          </div>
          
          <div class="search-section">
            <a-input-search
              v-model:value="searchValue"
              placeholder="输入关键词搜索方案，如：数据采集、机器视觉检测、智能仓储..."
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
        <div class="category-nav">
          <a-breadcrumb>
            <a-breadcrumb-item>
              <a @click="selectCategory('all')">全部方案</a>
            </a-breadcrumb-item>
            <a-breadcrumb-item v-if="selectedCategory !== 'all'">
              <a @click="selectCategory(selectedCategory)">{{ getCategoryName(selectedCategory) }}</a>
            </a-breadcrumb-item>
            <a-breadcrumb-item v-if="selectedSubCategory">
              {{ getSubCategoryName(selectedSubCategory) }}
            </a-breadcrumb-item>
          </a-breadcrumb>
        </div>
        
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
                  <span class="solution-count">{{ category.count }}个方案</span>
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
                  <span class="solution-count">{{ subcategory.count }}个方案</span>
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
              <label>行业分类</label>
              <a-cascader
                v-model:value="filters.industry"
                :options="industryOptions"
                placeholder="请选择行业"
                style="width: 200px"
              />
            </div>
            
            <div class="filter-group">
              <label>方案类型</label>
              <a-select v-model:value="filters.solutionType" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="intelligent-warehouse">智能仓储</a-select-option>
                <a-select-option value="energy-management">能源管理</a-select-option>
                <a-select-option value="predictive-maintenance">设备预测性维护</a-select-option>
                <a-select-option value="quality-control">质量控制</a-select-option>
                <a-select-option value="production-optimization">生产优化</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>技术架构</label>
              <a-select v-model:value="filters.architecture" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="cloud">云架构</a-select-option>
                <a-select-option value="edge">边缘计算</a-select-option>
                <a-select-option value="hybrid">混合架构</a-select-option>
                <a-select-option value="on-premise">本地部署</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>实施复杂度</label>
              <a-select v-model:value="filters.complexity" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="simple">简单</a-select-option>
                <a-select-option value="medium">中等</a-select-option>
                <a-select-option value="complex">复杂</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>投资规模</label>
              <a-select v-model:value="filters.investment" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="small">100万以下</a-select-option>
                <a-select-option value="medium">100-500万</a-select-option>
                <a-select-option value="large">500万以上</a-select-option>
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
            <span class="data-count">共有符合条件的方案 <strong>{{ totalCount }}</strong> 个</span>
          </div>
          <div class="data-actions">
            <a-button type="primary" @click="exportData">
              <DownloadOutlined />
              导出
            </a-button>
            <a-button @click="showAIDecomposition">
              <RobotOutlined />
              AI方案拆解
            </a-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 方案列表 -->
    <div class="solution-list">
      <div class="container">
        <div class="list-container">
          <div 
            v-for="solution in solutionList" 
            :key="solution.id"
            class="solution-item"
            @click="viewSolutionDetail(solution)"
          >
            <!-- 左侧方案图标 -->
            <div class="solution-icon">
              <component :is="solution.icon" />
            </div>
            
            <!-- 右侧方案信息 -->
            <div class="solution-info">
              <!-- 方案标题和标签 -->
              <div class="solution-header">
                <h3 class="solution-title">{{ solution.title }}</h3>
                <div class="solution-tags">
                  <a-tag 
                    v-for="tag in solution.tags" 
                    :key="tag"
                    :color="getTagColor(tag)"
                  >
                    {{ tag }}
                  </a-tag>
                </div>
              </div>
              
              <!-- 方案基本信息 -->
              <div class="solution-basic-info">
                <div class="info-row">
                  <span class="info-label">所属行业：</span>
                  <span class="info-value">{{ solution.industry }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">方案类型：</span>
                  <span class="info-value">{{ solution.type }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">技术架构：</span>
                  <span class="info-value">{{ solution.architecture }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">实施周期：</span>
                  <span class="info-value">{{ solution.implementationPeriod }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">投资规模：</span>
                  <span class="info-value">{{ solution.investment }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">ROI预期：</span>
                  <span class="info-value">{{ solution.roi }}</span>
                </div>
              </div>
              
              <!-- 方案描述 -->
              <div class="solution-description">
                <h4>方案概述</h4>
                <p>{{ solution.description }}</p>
              </div>
              
              <!-- 核心功能 -->
              <div class="solution-features">
                <h4>核心功能</h4>
                <div class="features-list">
                  <a-tag 
                    v-for="feature in solution.features" 
                    :key="feature"
                    class="feature-tag"
                  >
                    {{ feature }}
                  </a-tag>
                </div>
              </div>
              
              <!-- 技术栈 -->
              <div class="solution-tech-stack">
                <h4>技术栈</h4>
                <div class="tech-categories">
                  <div class="tech-category">
                    <span class="category-label">硬件：</span>
                    <div class="tech-tags">
                      <a-tag 
                        v-for="hardware in solution.hardware" 
                        :key="hardware"
                        color="blue"
                      >
                        {{ hardware }}
                      </a-tag>
                    </div>
                  </div>
                  <div class="tech-category">
                    <span class="category-label">软件：</span>
                    <div class="tech-tags">
                      <a-tag 
                        v-for="software in solution.software" 
                        :key="software"
                        color="green"
                      >
                        {{ software }}
                      </a-tag>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- 成功案例 -->
              <div class="solution-cases">
                <h4>成功案例</h4>
                <div class="cases-list">
                  <div 
                    v-for="caseItem in solution.cases" 
                    :key="caseItem.id"
                    class="case-item"
                  >
                    <span class="case-company">{{ caseItem.company }}</span>
                    <span class="case-result">{{ caseItem.result }}</span>
                  </div>
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

    <!-- AI方案拆解模态框 -->
    <a-modal
      v-model:open="aiDecompositionVisible"
      title="AI方案拆解"
      width="800px"
      :footer="null"
    >
      <div class="ai-decomposition">
        <div class="decomposition-header">
          <a-alert
            message="AI智能分析"
            description="通过大模型自动识别并提取方案中涉及的硬件和软件产品，生成物料清单"
            type="info"
            show-icon
          />
        </div>
        
        <div class="decomposition-content">
          <div class="analysis-section">
            <h4>方案分析结果</h4>
            <div class="analysis-result">
              <div class="result-item">
                <span class="result-label">识别硬件产品：</span>
                <span class="result-value">{{ aiAnalysis.hardwareCount }}个</span>
              </div>
              <div class="result-item">
                <span class="result-label">识别软件产品：</span>
                <span class="result-value">{{ aiAnalysis.softwareCount }}个</span>
              </div>
              <div class="result-item">
                <span class="result-label">匹配准确率：</span>
                <span class="result-value">{{ aiAnalysis.accuracy }}%</span>
              </div>
            </div>
          </div>
          
          <div class="bom-section">
            <h4>物料清单 (BOM List)</h4>
            <a-table
              :columns="bomColumns"
              :data-source="bomList"
              :pagination="false"
              size="small"
            />
          </div>
        </div>
      </div>
    </a-modal>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Header from '@/components/Header.vue'
import {
  SearchOutlined,
  DownloadOutlined,
  RobotOutlined,
  DatabaseOutlined,
  CloudOutlined,
  SettingOutlined,
  SafetyOutlined,
  BulbOutlined,
  ToolOutlined,
  ApiOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

// 搜索和筛选数据
const searchValue = ref('')
const selectedCategory = ref('all')
const selectedSubCategory = ref('')
const filters = reactive({
  industry: [],
  solutionType: 'all',
  architecture: 'all',
  complexity: 'all',
  investment: 'all'
})

// 分页数据
const currentPage = ref(1)
const pageSize = ref(10)
const totalCount = ref(12580)

// AI拆解相关
const aiDecompositionVisible = ref(false)
const aiAnalysis = reactive({
  hardwareCount: 8,
  softwareCount: 5,
  accuracy: 92
})

// 分类数据
const allCategories = [
  {
    key: 'manufacturing',
    name: '制造业',
    description: '智能制造、生产优化方案',
    icon: SettingOutlined,
    count: 3250
  },
  {
    key: 'energy',
    name: '能源管理',
    description: '能源监控、节能优化方案',
    icon: BulbOutlined,
    count: 1890
  },
  {
    key: 'logistics',
    name: '物流仓储',
    description: '智能仓储、物流优化方案',
    icon: DatabaseOutlined,
    count: 2150
  },
  {
    key: 'safety',
    name: '安全防护',
    description: '安全监控、防护系统方案',
    icon: SafetyOutlined,
    count: 1680
  },
  {
    key: 'quality',
    name: '质量控制',
    description: '质量检测、控制优化方案',
    icon: ToolOutlined,
    count: 1420
  },
  {
    key: 'iot',
    name: '物联网',
    description: 'IoT设备、数据采集方案',
    icon: ApiOutlined,
    count: 2190
  }
]

const categories = [
  {
    key: 'manufacturing',
    name: '制造业',
    children: [
      {
        key: 'production-optimization',
        name: '生产优化',
        description: '生产线效率提升、产能优化',
        count: 1200
      },
      {
        key: 'equipment-management',
        name: '设备管理',
        description: '设备监控、维护管理',
        count: 980
      },
      {
        key: 'quality-control',
        name: '质量控制',
        description: '质量检测、过程控制',
        count: 1070
      }
    ]
  },
  {
    key: 'energy',
    name: '能源管理',
    children: [
      {
        key: 'energy-monitoring',
        name: '能源监控',
        description: '能耗监测、数据分析',
        count: 850
      },
      {
        key: 'energy-optimization',
        name: '节能优化',
        description: '节能策略、优化建议',
        count: 1040
      }
    ]
  }
]

// 行业选项
const industryOptions = [
  {
    value: 'automotive',
    label: '汽车制造',
    children: [
      { value: 'auto-parts', label: '汽车零部件' },
      { value: 'auto-assembly', label: '汽车装配' }
    ]
  },
  {
    value: 'electronics',
    label: '电子制造',
    children: [
      { value: 'semiconductor', label: '半导体' },
      { value: 'consumer-electronics', label: '消费电子' }
    ]
  }
]

// 方案列表数据
const solutionList = ref([
  {
    id: 1,
    title: '智能仓储管理系统',
    icon: DatabaseOutlined,
    tags: ['智能仓储', 'WMS', '自动化'],
    industry: '制造业',
    type: '智能仓储',
    architecture: '云架构',
    implementationPeriod: '3-6个月',
    investment: '200-500万',
    roi: '15-25%',
    description: '基于物联网和人工智能技术的智能仓储管理系统，实现仓库作业自动化、库存精准管理和物流效率优化。',
    features: ['自动分拣', '库存管理', '路径优化', '异常预警', '数据分析'],
    hardware: ['RFID读写器', 'AGV小车', '输送线', '立体货架', '传感器'],
    software: ['WMS系统', 'TMS系统', '数据分析平台', '监控系统'],
    cases: [
      { id: 1, company: '某汽车制造企业', result: '效率提升30%，成本降低20%' },
      { id: 2, company: '某电商物流中心', result: '准确率提升至99.5%' }
    ]
  },
  {
    id: 2,
    title: '设备预测性维护系统',
    icon: ToolOutlined,
    tags: ['预测性维护', 'IoT', 'AI分析'],
    industry: '制造业',
    type: '设备预测性维护',
    architecture: '边缘计算',
    implementationPeriod: '2-4个月',
    investment: '100-300万',
    roi: '20-35%',
    description: '通过IoT传感器采集设备运行数据，利用机器学习算法预测设备故障，实现预防性维护。',
    features: ['故障预测', '健康监测', '维护建议', '报警通知', '趋势分析'],
    hardware: ['振动传感器', '温度传感器', '压力传感器', '边缘网关'],
    software: ['预测分析平台', '维护管理系统', '报警系统'],
    cases: [
      { id: 1, company: '某钢铁企业', result: '设备故障率降低40%' },
      { id: 2, company: '某化工企业', result: '维护成本节省25%' }
    ]
  }
])

// BOM表格列定义
const bomColumns = [
  {
    title: '产品类型',
    dataIndex: 'type',
    key: 'type',
    width: 100
  },
  {
    title: '产品名称',
    dataIndex: 'name',
    key: 'name'
  },
  {
    title: '品牌',
    dataIndex: 'brand',
    key: 'brand',
    width: 120
  },
  {
    title: '型号',
    dataIndex: 'model',
    key: 'model',
    width: 150
  },
  {
    title: '供应商',
    dataIndex: 'supplier',
    key: 'supplier',
    width: 150
  },
  {
    title: '建议数量',
    dataIndex: 'quantity',
    key: 'quantity',
    width: 100
  }
]

// BOM列表数据
const bomList = ref([
  {
    key: 1,
    type: '硬件',
    name: 'RFID读写器',
    brand: '霍尼韦尔',
    model: 'HF-2000',
    supplier: '霍尼韦尔中国',
    quantity: '10台'
  },
  {
    key: 2,
    type: '硬件',
    name: 'AGV小车',
    brand: '新松',
    model: 'AGV-500',
    supplier: '新松机器人',
    quantity: '5台'
  },
  {
    key: 3,
    type: '软件',
    name: 'WMS系统',
    brand: 'SAP',
    model: 'SAP EWM',
    supplier: 'SAP中国',
    quantity: '1套'
  }
])

// 方法
const handleSearch = (value) => {
  console.log('搜索方案:', value)
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

const getCategoryName = (key) => {
  const category = categories.find(c => c.key === key)
  return category ? category.name : '全部'
}

const getSubCategoryName = (key) => {
  for (const category of categories) {
    const subCategory = category.children.find(c => c.key === key)
    if (subCategory) return subCategory.name
  }
  return ''
}

const exportData = () => {
  console.log('导出方案数据')
}

const showAIDecomposition = () => {
  aiDecompositionVisible.value = true
}

const viewSolutionDetail = (solution) => {
  console.log('查看方案详情:', solution)
}

const getTagColor = (tag) => {
  const colorMap = {
    '智能仓储': 'blue',
    'WMS': 'green',
    '自动化': 'orange',
    '预测性维护': 'purple',
    'IoT': 'cyan',
    'AI分析': 'red'
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
  console.log('方案库页面加载完成')
})
</script>

<style lang="scss" scoped>
.solution-library {
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

.category-nav {
  margin-bottom: $spacing-lg;
  
  :deep(.ant-breadcrumb) {
    font-size: $font-size-md;
  }
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
  
  .solution-count {
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
  
  .solution-count {
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

.data-actions {
  display: flex;
  gap: $spacing-md;
}

// 方案列表
.solution-list {
  padding: $spacing-lg 0;
}

.list-container {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
}

.solution-item {
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

.solution-icon {
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

.solution-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: $spacing-md;
}

.solution-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: $spacing-md;
  
  .solution-title {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
    flex: 1;
  }
  
  .solution-tags {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
}

.solution-basic-info {
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

.solution-description {
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

.solution-features {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .features-list {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
  
  .feature-tag {
    margin: 0;
  }
}

.solution-tech-stack {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .tech-categories {
    display: flex;
    flex-direction: column;
    gap: $spacing-sm;
  }
  
  .tech-category {
    display: flex;
    align-items: center;
    gap: $spacing-sm;
    
    .category-label {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 60px;
    }
    
    .tech-tags {
      display: flex;
      flex-wrap: wrap;
      gap: $spacing-xs;
    }
  }
}

.solution-cases {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .cases-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .case-item {
    display: flex;
    gap: $spacing-md;
    
    .case-company {
      font-size: $font-size-sm;
      color: $text-primary;
      font-weight: 500;
      min-width: 120px;
    }
    
    .case-result {
      font-size: $font-size-sm;
      color: $text-secondary;
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

// AI拆解模态框
.ai-decomposition {
  .decomposition-header {
    margin-bottom: $spacing-lg;
  }
  
  .decomposition-content {
    .analysis-section {
      margin-bottom: $spacing-lg;
      
      h4 {
        font-size: $font-size-md;
        font-weight: 600;
        color: $text-primary;
        margin-bottom: $spacing-md;
      }
      
      .analysis-result {
        display: flex;
        gap: $spacing-lg;
        
        .result-item {
          display: flex;
          flex-direction: column;
          gap: $spacing-xs;
          
          .result-label {
            font-size: $font-size-sm;
            color: $text-secondary;
          }
          
          .result-value {
            font-size: $font-size-lg;
            font-weight: 600;
            color: $primary-color;
          }
        }
      }
    }
    
    .bom-section {
      h4 {
        font-size: $font-size-md;
        font-weight: 600;
        color: $text-primary;
        margin-bottom: $spacing-md;
      }
    }
  }
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
  
  .solution-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .solution-basic-info {
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
  
  .solution-item {
    flex-direction: column;
  }
  
  .solution-icon {
    align-self: center;
  }
}
</style>

