<template>
  <div class="policy-library">
    <Header />
    
    <div class="page-header">
      <div class="container">
        <div class="header-content">
          <div class="title-section">
            <h1 class="page-title">政策库</h1>
            <p class="page-subtitle">政策法规与申报指南，提供最新的政策信息和申报指导</p>
          </div>
          
          <div class="search-section">
            <a-input-search
              v-model:value="searchValue"
              placeholder="输入关键词搜索政策，如：政策名称、发布机构、适用行业..."
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
              <label>政策类型</label>
              <a-select v-model:value="filters.policyType" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="national">国家政策</a-select-option>
                <a-select-option value="local">地方政策</a-select-option>
                <a-select-option value="industry">行业政策</a-select-option>
                <a-select-option value="support">扶持政策</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>发布机构</label>
              <a-select v-model:value="filters.publisher" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="state-council">国务院</a-select-option>
                <a-select-option value="ministry">各部委</a-select-option>
                <a-select-option value="local-gov">地方政府</a-select-option>
                <a-select-option value="industry-assoc">行业协会</a-select-option>
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
          </div>
        </div>
      </div>
    </div>

    <div class="data-section">
      <div class="container">
        <div class="data-header">
          <div class="data-info">
            <span class="data-count">共有符合条件的政策 <strong>{{ totalCount }}</strong> 条</span>
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

    <div class="policy-list">
      <div class="container">
        <div class="list-container">
          <div 
            v-for="policy in policyList" 
            :key="policy.id"
            class="policy-item"
            @click="viewPolicyDetail(policy)"
          >
            <div class="policy-icon">
              <FileTextOutlined />
            </div>
            
            <div class="policy-info">
              <div class="policy-header">
                <h3 class="policy-title">{{ policy.title }}</h3>
                <div class="policy-tags">
                  <a-tag 
                    v-for="tag in policy.tags" 
                    :key="tag"
                    :color="getTagColor(tag)"
                  >
                    {{ tag }}
                  </a-tag>
                </div>
              </div>
              
              <div class="policy-basic-info">
                <div class="info-row">
                  <span class="info-label">政策类型：</span>
                  <span class="info-value">{{ policy.type }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">发布机构：</span>
                  <span class="info-value">{{ policy.publisher }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">文号：</span>
                  <span class="info-value">{{ policy.documentNumber }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">发布日期：</span>
                  <span class="info-value">{{ policy.publishDate }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">实施日期：</span>
                  <span class="info-value">{{ policy.effectiveDate }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">适用行业：</span>
                  <span class="info-value">{{ policy.applicableIndustry }}</span>
                </div>
              </div>
              
              <div class="policy-summary">
                <h4>政策摘要</h4>
                <p>{{ policy.summary }}</p>
              </div>
              
              <div class="policy-benefits">
                <h4>政策优惠</h4>
                <div class="benefits-list">
                  <div 
                    v-for="benefit in policy.benefits" 
                    :key="benefit.id"
                    class="benefit-item"
                  >
                    <span class="benefit-type">{{ benefit.type }}：</span>
                    <span class="benefit-content">{{ benefit.content }}</span>
                  </div>
                </div>
              </div>
              
              <div class="policy-requirements">
                <h4>申报条件</h4>
                <div class="requirements-list">
                  <div 
                    v-for="requirement in policy.requirements" 
                    :key="requirement.id"
                    class="requirement-item"
                  >
                    <span class="requirement-number">{{ requirement.number }}.</span>
                    <span class="requirement-content">{{ requirement.content }}</span>
                  </div>
                </div>
              </div>
              
              <div class="policy-procedures">
                <h4>申报流程</h4>
                <div class="procedures-list">
                  <div 
                    v-for="procedure in policy.procedures" 
                    :key="procedure.id"
                    class="procedure-item"
                  >
                    <span class="procedure-step">{{ procedure.step }}</span>
                    <span class="procedure-content">{{ procedure.content }}</span>
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
  FileTextOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

const searchValue = ref('')
const filters = reactive({
  policyType: 'all',
  publisher: 'all',
  industry: 'all',
  dateRange: []
})

const currentPage = ref(1)
const pageSize = ref(10)
const totalCount = ref(2580)

const policyList = ref([
  {
    id: 1,
    title: '关于支持制造业高质量发展的若干政策措施',
    tags: ['国家政策', '制造业', '高质量发展'],
    type: '国家政策',
    publisher: '国务院',
    documentNumber: '国发〔2024〕1号',
    publishDate: '2024-01-15',
    effectiveDate: '2024-02-01',
    applicableIndustry: '制造业',
    summary: '为支持制造业高质量发展，国家出台了一系列政策措施，包括税收优惠、资金支持、技术创新等方面的扶持政策。',
    benefits: [
      { id: 1, type: '税收优惠', content: '高新技术企业享受15%企业所得税优惠税率' },
      { id: 2, type: '资金支持', content: '设立制造业发展专项资金，支持企业技术改造' },
      { id: 3, type: '技术创新', content: '支持企业建立研发中心，给予研发费用加计扣除' }
    ],
    requirements: [
      { id: 1, number: 1, content: '企业具有独立法人资格，注册地在中华人民共和国境内' },
      { id: 2, number: 2, content: '企业主营业务属于制造业范畴' },
      { id: 3, number: 3, content: '企业具有健全的财务管理制度和会计核算体系' },
      { id: 4, number: 4, content: '企业近三年无重大违法违规记录' }
    ],
    procedures: [
      { id: 1, step: '第一步', content: '企业准备申报材料，包括营业执照、财务报表等' },
      { id: 2, step: '第二步', content: '通过线上平台提交申报材料' },
      { id: 3, step: '第三步', content: '相关部门进行材料审核和现场核查' },
      { id: 4, step: '第四步', content: '审核通过后，企业享受相应政策优惠' }
    ]
  }
])

const handleSearch = (value) => {
  console.log('搜索政策:', value)
}

const exportData = () => {
  console.log('导出政策数据')
}

const viewPolicyDetail = (policy) => {
  console.log('查看政策详情:', policy)
}

const getTagColor = (tag) => {
  const colorMap = {
    '国家政策': 'red',
    '地方政策': 'blue',
    '行业政策': 'green',
    '扶持政策': 'orange',
    '制造业': 'purple',
    '高质量发展': 'cyan'
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
  console.log('政策库页面加载完成')
})
</script>

<style lang="scss" scoped>
.policy-library {
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

.policy-list {
  padding: $spacing-lg 0;
}

.list-container {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
}

.policy-item {
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

.policy-icon {
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

.policy-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: $spacing-md;
}

.policy-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: $spacing-md;
  
  .policy-title {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
    flex: 1;
  }
  
  .policy-tags {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
}

.policy-basic-info {
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

.policy-summary {
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

.policy-benefits {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .benefits-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .benefit-item {
    display: flex;
    gap: $spacing-xs;
    
    .benefit-type {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 80px;
    }
    
    .benefit-content {
      font-size: $font-size-sm;
      color: $text-primary;
    }
  }
}

.policy-requirements {
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
    
    .requirement-number {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 20px;
    }
    
    .requirement-content {
      font-size: $font-size-sm;
      color: $text-primary;
    }
  }
}

.policy-procedures {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .procedures-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .procedure-item {
    display: flex;
    gap: $spacing-xs;
    
    .procedure-step {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 60px;
    }
    
    .procedure-content {
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
  
  .policy-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .policy-basic-info {
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
  
  .policy-item {
    flex-direction: column;
  }
  
  .policy-icon {
    align-self: center;
  }
}
</style>

