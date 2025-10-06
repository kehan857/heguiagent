<template>
  <div class="industry-problem-library">
    <Header />
    
    <div class="page-header">
      <div class="container">
        <div class="header-content">
          <div class="title-section">
            <h1 class="page-title">行业问题库</h1>
            <p class="page-subtitle">行业痛点与解决方案，汇聚行业共性问题及最佳实践</p>
          </div>
          
          <div class="search-section">
            <a-input-search
              v-model:value="searchValue"
              placeholder="输入关键词搜索问题，如：问题类型、行业领域、解决方案..."
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
              <label>问题类型</label>
              <a-select v-model:value="filters.problemType" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="technical">技术问题</a-select-option>
                <a-select-option value="management">管理问题</a-select-option>
                <a-select-option value="safety">安全问题</a-select-option>
                <a-select-option value="efficiency">效率问题</a-select-option>
                <a-select-option value="cost">成本问题</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>行业领域</label>
              <a-select v-model:value="filters.industry" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="manufacturing">制造业</a-select-option>
                <a-select-option value="energy">能源</a-select-option>
                <a-select-option value="chemical">化工</a-select-option>
                <a-select-option value="automotive">汽车</a-select-option>
                <a-select-option value="pharmaceutical">制药</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>问题严重程度</label>
              <a-select v-model:value="filters.severity" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="critical">严重</a-select-option>
                <a-select-option value="high">高</a-select-option>
                <a-select-option value="medium">中</a-select-option>
                <a-select-option value="low">低</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>解决状态</label>
              <a-select v-model:value="filters.status" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="solved">已解决</a-select-option>
                <a-select-option value="solving">解决中</a-select-option>
                <a-select-option value="pending">待解决</a-select-option>
              </a-select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="data-section">
      <div class="container">
        <div class="data-header">
          <div class="data-info">
            <span class="data-count">共有符合条件的问题 <strong>{{ totalCount }}</strong> 个</span>
          </div>
          <div class="data-actions">
            <a-button type="primary" @click="exportData">
              <DownloadOutlined />
              导出
            </a-button>
            <a-button @click="submitProblem">
              <PlusOutlined />
              提交问题
            </a-button>
          </div>
        </div>
      </div>
    </div>

    <div class="problem-list">
      <div class="container">
        <div class="list-container">
          <div 
            v-for="problem in problemList" 
            :key="problem.id"
            class="problem-item"
            @click="viewProblemDetail(problem)"
          >
            <div class="problem-icon">
              <QuestionCircleOutlined />
            </div>
            
            <div class="problem-info">
              <div class="problem-header">
                <h3 class="problem-title">{{ problem.title }}</h3>
                <div class="problem-tags">
                  <a-tag 
                    v-for="tag in problem.tags" 
                    :key="tag"
                    :color="getTagColor(tag)"
                  >
                    {{ tag }}
                  </a-tag>
                </div>
              </div>
              
              <div class="problem-basic-info">
                <div class="info-row">
                  <span class="info-label">问题类型：</span>
                  <span class="info-value">{{ problem.type }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">行业领域：</span>
                  <span class="info-value">{{ problem.industry }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">严重程度：</span>
                  <span class="info-value">
                    <a-tag :color="getSeverityColor(problem.severity)">
                      {{ problem.severity }}
                    </a-tag>
                  </span>
                </div>
                <div class="info-row">
                  <span class="info-label">提交时间：</span>
                  <span class="info-value">{{ problem.submitDate }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">解决状态：</span>
                  <span class="info-value">
                    <a-tag :color="getStatusColor(problem.status)">
                      {{ problem.status }}
                    </a-tag>
                  </span>
                </div>
                <div class="info-row">
                  <span class="info-label">影响企业：</span>
                  <span class="info-value">{{ problem.affectedCompanies }}家</span>
                </div>
              </div>
              
              <div class="problem-description">
                <h4>问题描述</h4>
                <p>{{ problem.description }}</p>
              </div>
              
              <div class="problem-impact">
                <h4>影响分析</h4>
                <div class="impact-list">
                  <div 
                    v-for="impact in problem.impacts" 
                    :key="impact.id"
                    class="impact-item"
                  >
                    <span class="impact-type">{{ impact.type }}：</span>
                    <span class="impact-content">{{ impact.content }}</span>
                  </div>
                </div>
              </div>
              
              <div class="problem-solutions">
                <h4>解决方案</h4>
                <div class="solutions-list">
                  <div 
                    v-for="solution in problem.solutions" 
                    :key="solution.id"
                    class="solution-item"
                  >
                    <div class="solution-header">
                      <span class="solution-title">{{ solution.title }}</span>
                      <a-tag :color="getSolutionStatusColor(solution.status)">
                        {{ solution.status }}
                      </a-tag>
                    </div>
                    <p class="solution-description">{{ solution.description }}</p>
                    <div class="solution-metrics">
                      <span class="metric-item">
                        <span class="metric-label">成功率：</span>
                        <span class="metric-value">{{ solution.successRate }}%</span>
                      </span>
                      <span class="metric-item">
                        <span class="metric-label">实施成本：</span>
                        <span class="metric-value">{{ solution.cost }}</span>
                      </span>
                      <span class="metric-item">
                        <span class="metric-label">实施周期：</span>
                        <span class="metric-value">{{ solution.duration }}</span>
                      </span>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="problem-cases">
                <h4>典型案例</h4>
                <div class="cases-list">
                  <div 
                    v-for="caseItem in problem.cases" 
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
  QuestionCircleOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

const searchValue = ref('')
const filters = reactive({
  problemType: 'all',
  industry: 'all',
  severity: 'all',
  status: 'all'
})

const currentPage = ref(1)
const pageSize = ref(10)
const totalCount = ref(1850)

const problemList = ref([
  {
    id: 1,
    title: '防爆设备维护成本高、效率低的问题',
    tags: ['技术问题', '成本问题', '维护管理'],
    type: '技术问题',
    industry: '制造业',
    severity: '高',
    submitDate: '2024-01-10',
    status: '解决中',
    affectedCompanies: 1250,
    description: '在石油化工、煤矿等危险环境中，防爆设备的维护成本居高不下，维护效率低下，严重影响企业生产效率和经济效益。',
    impacts: [
      { id: 1, type: '成本影响', content: '维护成本占设备总成本的30-40%' },
      { id: 2, type: '效率影响', content: '设备停机时间增加20-30%' },
      { id: 3, type: '安全影响', content: '维护不当可能导致安全事故' }
    ],
    solutions: [
      {
        id: 1,
        title: '预测性维护方案',
        status: '已验证',
        description: '通过IoT传感器和AI算法，实现设备状态实时监测和故障预测，提前安排维护计划。',
        successRate: 85,
        cost: '中等',
        duration: '3-6个月'
      },
      {
        id: 2,
        title: '标准化维护流程',
        status: '实施中',
        description: '建立标准化的维护流程和作业指导书，提高维护效率和质量。',
        successRate: 75,
        cost: '低',
        duration: '1-3个月'
      }
    ],
    cases: [
      { id: 1, company: '某石化企业', result: '维护成本降低25%，设备可用率提升15%' },
      { id: 2, company: '某煤矿企业', result: '故障率降低30%，维护效率提升40%' }
    ]
  }
])

const handleSearch = (value) => {
  console.log('搜索问题:', value)
}

const exportData = () => {
  console.log('导出问题数据')
}

const submitProblem = () => {
  console.log('提交问题')
}

const viewProblemDetail = (problem) => {
  console.log('查看问题详情:', problem)
}

const getTagColor = (tag) => {
  const colorMap = {
    '技术问题': 'blue',
    '管理问题': 'green',
    '安全问题': 'red',
    '效率问题': 'orange',
    '成本问题': 'purple',
    '维护管理': 'cyan'
  }
  return colorMap[tag] || 'default'
}

const getSeverityColor = (severity) => {
  const colorMap = {
    '严重': 'red',
    '高': 'orange',
    '中': 'yellow',
    '低': 'green'
  }
  return colorMap[severity] || 'default'
}

const getStatusColor = (status) => {
  const colorMap = {
    '已解决': 'green',
    '解决中': 'blue',
    '待解决': 'orange'
  }
  return colorMap[status] || 'default'
}

const getSolutionStatusColor = (status) => {
  const colorMap = {
    '已验证': 'green',
    '实施中': 'blue',
    '待验证': 'orange'
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
  console.log('行业问题库页面加载完成')
})
</script>

<style lang="scss" scoped>
.industry-problem-library {
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

.problem-list {
  padding: $spacing-lg 0;
}

.list-container {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
}

.problem-item {
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

.problem-icon {
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

.problem-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: $spacing-md;
}

.problem-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: $spacing-md;
  
  .problem-title {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
    flex: 1;
  }
  
  .problem-tags {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
}

.problem-basic-info {
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

.problem-description {
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

.problem-impact {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .impact-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .impact-item {
    display: flex;
    gap: $spacing-xs;
    
    .impact-type {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 80px;
    }
    
    .impact-content {
      font-size: $font-size-sm;
      color: $text-primary;
    }
  }
}

.problem-solutions {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .solutions-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-md;
  }
  
  .solution-item {
    background: $bg-secondary;
    border-radius: $border-radius;
    padding: $spacing-md;
    border: 1px solid $border-light;
    
    .solution-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: $spacing-sm;
      
      .solution-title {
        font-size: $font-size-md;
        font-weight: 600;
        color: $text-primary;
      }
    }
    
    .solution-description {
      color: $text-secondary;
      line-height: 1.6;
      margin-bottom: $spacing-sm;
    }
    
    .solution-metrics {
      display: flex;
      gap: $spacing-lg;
      
      .metric-item {
        display: flex;
        gap: $spacing-xs;
        
        .metric-label {
          font-size: $font-size-sm;
          color: $text-secondary;
        }
        
        .metric-value {
          font-size: $font-size-sm;
          color: $text-primary;
          font-weight: 500;
        }
      }
    }
  }
}

.problem-cases {
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
  
  .problem-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .problem-basic-info {
    grid-template-columns: 1fr;
  }
  
  .solution-metrics {
    flex-direction: column !important;
    gap: $spacing-sm !important;
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
  
  .problem-item {
    flex-direction: column;
  }
  
  .problem-icon {
    align-self: center;
  }
}
</style>

