<template>
  <div class="talent-library">
    <Header />
    
    <div class="page-header">
      <div class="container">
        <div class="header-content">
          <div class="title-section">
            <h1 class="page-title">人才库</h1>
            <p class="page-subtitle">专业人才信息管理，汇聚行业精英和技术专家</p>
          </div>
          
          <div class="search-section">
            <a-input-search
              v-model:value="searchValue"
              placeholder="输入关键词搜索人才，如：姓名、专业、技能、公司..."
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
              <label>专业领域</label>
              <a-select v-model:value="filters.field" placeholder="请选择" style="width: 150px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="safety">安全防护</a-select-option>
                <a-select-option value="automation">自动化</a-select-option>
                <a-select-option value="iot">物联网</a-select-option>
                <a-select-option value="ai">人工智能</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>技能等级</label>
              <a-select v-model:value="filters.level" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="expert">专家</a-select-option>
                <a-select-option value="senior">高级</a-select-option>
                <a-select-option value="intermediate">中级</a-select-option>
                <a-select-option value="junior">初级</a-select-option>
              </a-select>
            </div>
            
            <div class="filter-group">
              <label>工作年限</label>
              <a-select v-model:value="filters.experience" placeholder="请选择" style="width: 120px">
                <a-select-option value="all">全部</a-select-option>
                <a-select-option value="10+">10年以上</a-select-option>
                <a-select-option value="5-10">5-10年</a-select-option>
                <a-select-option value="3-5">3-5年</a-select-option>
                <a-select-option value="1-3">1-3年</a-select-option>
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
            <span class="data-count">共有符合条件的专业人才 <strong>{{ totalCount }}</strong> 人</span>
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

    <div class="talent-list">
      <div class="container">
        <div class="list-container">
          <div 
            v-for="talent in talentList" 
            :key="talent.id"
            class="talent-item"
            @click="viewTalentDetail(talent)"
          >
            <div class="talent-avatar">
              <a-avatar :size="60" :src="talent.avatar">
                {{ talent.name.charAt(0) }}
              </a-avatar>
            </div>
            
            <div class="talent-info">
              <div class="talent-header">
                <h3 class="talent-name">{{ talent.name }}</h3>
                <div class="talent-tags">
                  <a-tag 
                    v-for="tag in talent.tags" 
                    :key="tag"
                    :color="getTagColor(tag)"
                  >
                    {{ tag }}
                  </a-tag>
                </div>
              </div>
              
              <div class="talent-basic-info">
                <div class="info-row">
                  <span class="info-label">专业领域：</span>
                  <span class="info-value">{{ talent.field }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">技能等级：</span>
                  <span class="info-value">{{ talent.level }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">工作年限：</span>
                  <span class="info-value">{{ talent.experience }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">所在公司：</span>
                  <span class="info-value">{{ talent.company }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">所在地区：</span>
                  <span class="info-value">{{ talent.location }}</span>
                </div>
                <div class="info-row">
                  <span class="info-label">联系方式：</span>
                  <span class="info-value">{{ talent.contact }}</span>
                </div>
              </div>
              
              <div class="talent-skills">
                <h4>专业技能</h4>
                <div class="skills-list">
                  <a-tag 
                    v-for="skill in talent.skills" 
                    :key="skill"
                    class="skill-tag"
                  >
                    {{ skill }}
                  </a-tag>
                </div>
              </div>
              
              <div class="talent-experience">
                <h4>工作经历</h4>
                <div class="experience-list">
                  <div 
                    v-for="exp in talent.experiences" 
                    :key="exp.id"
                    class="experience-item"
                  >
                    <span class="exp-period">{{ exp.period }}</span>
                    <span class="exp-company">{{ exp.company }}</span>
                    <span class="exp-position">{{ exp.position }}</span>
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
  DownloadOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

const searchValue = ref('')
const filters = reactive({
  field: 'all',
  level: 'all',
  experience: 'all',
  region: []
})

const currentPage = ref(1)
const pageSize = ref(10)
const totalCount = ref(12580)

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

const talentList = ref([
  {
    id: 1,
    name: '张工程师',
    avatar: '/api/placeholder/60/60',
    tags: ['防爆专家', '高级工程师', '技术总监'],
    field: '安全防护',
    level: '专家',
    experience: '15年',
    company: '某防爆设备制造企业',
    location: '北京市',
    contact: 'zhang@example.com',
    skills: ['防爆设计', '安全评估', '标准制定', '项目管理', '团队领导'],
    experiences: [
      { id: 1, period: '2018-至今', company: '某防爆设备制造企业', position: '技术总监' },
      { id: 2, period: '2015-2018', company: '某安全技术公司', position: '高级工程师' }
    ]
  }
])

const handleSearch = (value) => {
  console.log('搜索人才:', value)
}

const exportData = () => {
  console.log('导出人才数据')
}

const viewTalentDetail = (talent) => {
  console.log('查看人才详情:', talent)
}

const getTagColor = (tag) => {
  const colorMap = {
    '防爆专家': 'red',
    '高级工程师': 'blue',
    '技术总监': 'green',
    '项目经理': 'orange',
    '研发专家': 'purple'
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
  console.log('人才库页面加载完成')
})
</script>

<style lang="scss" scoped>
.talent-library {
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

.talent-list {
  padding: $spacing-lg 0;
}

.list-container {
  display: flex;
  flex-direction: column;
  gap: $spacing-lg;
}

.talent-item {
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

.talent-avatar {
  flex-shrink: 0;
}

.talent-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: $spacing-md;
}

.talent-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: $spacing-md;
  
  .talent-name {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
    flex: 1;
  }
  
  .talent-tags {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
}

.talent-basic-info {
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

.talent-skills {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .skills-list {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
  
  .skill-tag {
    margin: 0;
  }
}

.talent-experience {
  h4 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  .experience-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-xs;
  }
  
  .experience-item {
    display: flex;
    gap: $spacing-md;
    
    .exp-period {
      font-size: $font-size-sm;
      color: $text-secondary;
      min-width: 80px;
    }
    
    .exp-company {
      font-size: $font-size-sm;
      color: $text-primary;
      font-weight: 500;
      min-width: 150px;
    }
    
    .exp-position {
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
  
  .talent-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .talent-basic-info {
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
  
  .talent-item {
    flex-direction: column;
  }
  
  .talent-avatar {
    align-self: center;
  }
}
</style>

