<template>
  <div class="enterprise-detail">
    <!-- 顶部导航 -->
    <Header />
    
    <!-- 企业基础信息头部 -->
    <div class="enterprise-header">
      <div class="container">
        <div class="header-content">
          <div class="enterprise-logo">
            <img 
              :src="enterpriseInfo.logo" 
              :alt="enterpriseInfo.name"
              @error="handleImageError"
            />
          </div>
          
          <div class="enterprise-basic">
            <h1 class="enterprise-name">{{ enterpriseInfo.name }}</h1>
            <div class="enterprise-tags">
              <a-tag 
                v-for="tag in enterpriseInfo.tags" 
                :key="tag"
                :color="getTagColor(tag)"
                class="enterprise-tag"
              >
                {{ tag }}
              </a-tag>
            </div>
            
            <div class="basic-info-grid">
              <div class="info-item">
                <span class="info-label">统一社会信用代码：</span>
                <span class="info-value">{{ enterpriseInfo.creditCode }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">注册资本：</span>
                <span class="info-value">{{ enterpriseInfo.registeredCapital }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">成立日期：</span>
                <span class="info-value">{{ enterpriseInfo.establishmentDate }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">法人代表：</span>
                <span class="info-value">{{ enterpriseInfo.legalPerson }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">经营状态：</span>
                <span class="info-value">
                  <a-tag :color="getStatusColor(enterpriseInfo.status)">
                    {{ enterpriseInfo.status }}
                  </a-tag>
                </span>
              </div>
              <div class="info-item">
                <span class="info-label">所在地区：</span>
                <span class="info-value">{{ enterpriseInfo.location }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <div class="container">
        <div class="content-layout">
          <!-- 左侧菜单栏 -->
          <div class="sidebar">
            <a-menu
              v-model:selectedKeys="selectedMenuKey"
              mode="vertical"
              class="sidebar-menu"
              @click="handleMenuClick"
            >
              <a-menu-item key="basic">
                <template #icon>
                  <BankOutlined />
                </template>
                基本工商信息
              </a-menu-item>
              <a-menu-item key="products">
                <template #icon>
                  <AppstoreOutlined />
                </template>
                产品方案信息
              </a-menu-item>
              <a-menu-item key="honors">
                <template #icon>
                  <TrophyOutlined />
                </template>
                企业荣誉标签
              </a-menu-item>
              <a-menu-item key="industry-chain">
                <template #icon>
                  <NodeIndexOutlined />
                </template>
                产业链位置
              </a-menu-item>
              <a-menu-item key="industry">
                <template #icon>
                  <GlobalOutlined />
                </template>
                所属适配行业
              </a-menu-item>
              <a-menu-item key="standards">
                <template #icon>
                  <FileTextOutlined />
                </template>
                适配行业标准
              </a-menu-item>
              <a-menu-item key="solutions">
                <template #icon>
                  <SolutionOutlined />
                </template>
                适配行业方案
              </a-menu-item>
              <a-menu-item key="problems">
                <template #icon>
                  <QuestionCircleOutlined />
                </template>
                行业问题关联
              </a-menu-item>
              <a-menu-item key="policies">
                <template #icon>
                  <FileProtectOutlined />
                </template>
                适配政策
              </a-menu-item>
              <a-menu-item key="bidding">
                <template #icon>
                  <AuditOutlined />
                </template>
                招投标信息
              </a-menu-item>
              <a-menu-item key="talents">
                <template #icon>
                  <TeamOutlined />
                </template>
                人才信息
              </a-menu-item>
            </a-menu>
          </div>

          <!-- 右侧内容区域 -->
          <div class="content-area">
            <!-- 基本工商信息 -->
            <div v-if="selectedMenuKey[0] === 'basic'" class="content-panel">
              <div class="panel-header">
                <h2>基本工商信息</h2>
                <p>企业的基本工商注册信息和变更记录</p>
              </div>
              
              <div class="panel-content">
                <a-row :gutter="[24, 24]">
                  <a-col :span="12">
                    <div class="info-section">
                      <h3>股东信息</h3>
                      <a-table
                        :columns="shareholderColumns"
                        :data-source="enterpriseInfo.shareholders"
                        :pagination="false"
                        size="small"
                      />
                    </div>
                  </a-col>
                  
                  <a-col :span="12">
                    <div class="info-section">
                      <h3>主要人员</h3>
                      <a-table
                        :columns="personnelColumns"
                        :data-source="enterpriseInfo.personnel"
                        :pagination="false"
                        size="small"
                      />
                    </div>
                  </a-col>
                  
                  <a-col :span="24">
                    <div class="info-section">
                      <h3>分支机构</h3>
                      <a-table
                        :columns="branchColumns"
                        :data-source="enterpriseInfo.branches"
                        :pagination="false"
                        size="small"
                      />
                    </div>
                  </a-col>
                  
                  <a-col :span="24">
                    <div class="info-section">
                      <h3>变更记录</h3>
                      <a-timeline>
                        <a-timeline-item
                          v-for="change in enterpriseInfo.changes"
                          :key="change.id"
                          :color="getChangeColor(change.type)"
                        >
                          <div class="change-item">
                            <div class="change-header">
                              <span class="change-date">{{ change.date }}</span>
                              <a-tag :color="getChangeColor(change.type)">{{ change.type }}</a-tag>
                            </div>
                            <div class="change-content">{{ change.content }}</div>
                          </div>
                        </a-timeline-item>
                      </a-timeline>
                    </div>
                  </a-col>
                </a-row>
              </div>
            </div>

            <!-- 产品方案信息 -->
            <div v-if="selectedMenuKey[0] === 'products'" class="content-panel">
              <div class="panel-header">
                <h2>产品方案信息</h2>
                <p>企业对外提供的核心产品和解决方案</p>
              </div>
              
              <div class="panel-content">
                <div class="products-grid">
                  <div 
                    v-for="product in enterpriseInfo.products" 
                    :key="product.id"
                    class="product-card"
                  >
                    <div class="product-header">
                      <h3>{{ product.name }}</h3>
                      <a-tag :color="getProductTypeColor(product.type)">{{ product.type }}</a-tag>
                    </div>
                    <p class="product-description">{{ product.description }}</p>
                    <div class="product-features">
                      <h4>核心特性</h4>
                      <div class="features-list">
                        <a-tag 
                          v-for="feature in product.features" 
                          :key="feature"
                          class="feature-tag"
                        >
                          {{ feature }}
                        </a-tag>
                      </div>
                    </div>
                    <div class="product-applications">
                      <h4>应用场景</h4>
                      <div class="applications-list">
                        <a-tag 
                          v-for="app in product.applications" 
                          :key="app"
                          color="blue"
                        >
                          {{ app }}
                        </a-tag>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 企业荣誉标签 -->
            <div v-if="selectedMenuKey[0] === 'honors'" class="content-panel">
              <div class="panel-header">
                <h2>企业荣誉标签</h2>
                <p>企业获得的各种认证和荣誉</p>
              </div>
              
              <div class="panel-content">
                <div class="honors-grid">
                  <div 
                    v-for="honor in enterpriseInfo.honors" 
                    :key="honor.id"
                    class="honor-card"
                  >
                    <div class="honor-icon">
                      <component :is="honor.icon" />
                    </div>
                    <div class="honor-content">
                      <h3>{{ honor.name }}</h3>
                      <p>{{ honor.description }}</p>
                      <div class="honor-meta">
                        <span class="honor-date">获得时间：{{ honor.date }}</span>
                        <span class="honor-issuer">颁发机构：{{ honor.issuer }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 产业链位置 -->
            <div v-if="selectedMenuKey[0] === 'industry-chain'" class="content-panel">
              <div class="panel-header">
                <h2>产业链位置</h2>
                <p>企业在产业链中的位置和上下游关系</p>
              </div>
              
              <div class="panel-content">
                <div class="industry-chain-visual">
                  <div class="chain-flow">
                    <div class="chain-node upstream">
                      <h4>上游企业</h4>
                      <div class="company-list">
                        <div 
                          v-for="company in enterpriseInfo.upstreamCompanies" 
                          :key="company.id"
                          class="company-item"
                        >
                          <span class="company-name">{{ company.name }}</span>
                          <span class="relationship">{{ company.relationship }}</span>
                        </div>
                      </div>
                    </div>
                    
                    <div class="chain-node current">
                      <h4>当前企业</h4>
                      <div class="current-company">
                        <strong>{{ enterpriseInfo.name }}</strong>
                        <span class="position">{{ enterpriseInfo.chainPosition }}</span>
                      </div>
                    </div>
                    
                    <div class="chain-node downstream">
                      <h4>下游企业</h4>
                      <div class="company-list">
                        <div 
                          v-for="company in enterpriseInfo.downstreamCompanies" 
                          :key="company.id"
                          class="company-item"
                        >
                          <span class="company-name">{{ company.name }}</span>
                          <span class="relationship">{{ company.relationship }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 其他模块内容 -->
            <div v-if="selectedMenuKey[0] === 'industry'" class="content-panel">
              <div class="panel-header">
                <h2>所属适配行业</h2>
                <p>企业所属的行业分类和适配的行业领域</p>
              </div>
              <div class="panel-content">
                <a-empty description="该模块内容正在开发中..." />
              </div>
            </div>

            <div v-if="selectedMenuKey[0] === 'standards'" class="content-panel">
              <div class="panel-header">
                <h2>适配行业标准</h2>
                <p>企业适用的行业标准和国家标准</p>
              </div>
              <div class="panel-content">
                <div class="standards-list">
                  <a-card 
                    v-for="standard in enterpriseInfo.industryStandards" 
                    :key="standard.id"
                    class="standard-card"
                    :bordered="false"
                  >
                    <template #title>
                      <div class="standard-header">
                        <h3 class="standard-name">{{ standard.name }}</h3>
                        <div class="standard-badges">
                          <a-tag :color="getStandardTypeColor(standard.type)">{{ standard.type }}</a-tag>
                          <a-tag :color="getStandardCategoryColor(standard.category)">{{ standard.category }}</a-tag>
                          <a-tag :color="standard.status === '现行' ? 'green' : 'orange'">{{ standard.status }}</a-tag>
                        </div>
                      </div>
                    </template>
                    
                    <div class="standard-content">
                      <a-descriptions :column="2" size="small">
                        <a-descriptions-item label="适用范围">{{ standard.applicableScope }}</a-descriptions-item>
                        <a-descriptions-item label="相关产品">
                          <a-tag v-for="product in standard.relatedProducts" :key="product" color="blue">
                            {{ product }}
                          </a-tag>
                        </a-descriptions-item>
                      </a-descriptions>
                      
                      <div class="standard-description">
                        <h4>标准描述</h4>
                        <p>{{ standard.description }}</p>
                      </div>
                    </div>
                  </a-card>
                </div>
              </div>
            </div>

            <div v-if="selectedMenuKey[0] === 'solutions'" class="content-panel">
              <div class="panel-header">
                <h2>适配行业方案</h2>
                <p>企业已应用或可适配的行业解决方案</p>
              </div>
              <div class="panel-content">
                <div class="solutions-list">
                  <a-card 
                    v-for="solution in enterpriseInfo.industrySolutions" 
                    :key="solution.id"
                    class="solution-card"
                    :bordered="false"
                  >
                    <template #title>
                      <div class="solution-header">
                        <h3 class="solution-name">{{ solution.name }}</h3>
                        <div class="solution-badges">
                          <a-tag :color="getSolutionTypeColor(solution.type)">{{ solution.type }}</a-tag>
                          <a-tag color="blue">{{ solution.industry }}</a-tag>
                        </div>
                      </div>
                    </template>
                    
                    <div class="solution-content">
                      <div class="solution-description">
                        <h4>方案描述</h4>
                        <p>{{ solution.description }}</p>
                      </div>
                      
                      <a-descriptions :column="2" size="small">
                        <a-descriptions-item label="实施周期">{{ solution.implementationPeriod }}</a-descriptions-item>
                        <a-descriptions-item label="投资规模">{{ solution.investment }}</a-descriptions-item>
                      </a-descriptions>
                      
                      <div class="solution-features">
                        <h4>核心功能</h4>
                        <div class="feature-tags">
                          <a-tag v-for="feature in solution.features" :key="feature" color="green">
                            {{ feature }}
                          </a-tag>
                        </div>
                      </div>
                      
                      <div class="solution-applications">
                        <h4>应用场景</h4>
                        <div class="application-tags">
                          <a-tag v-for="app in solution.applications" :key="app" color="orange">
                            {{ app }}
                          </a-tag>
                        </div>
                      </div>
                      
                      <div class="solution-cases">
                        <h4>成功案例</h4>
                        <div class="case-tags">
                          <a-tag v-for="caseItem in solution.successCases" :key="caseItem" color="purple">
                            {{ caseItem }}
                          </a-tag>
                        </div>
                      </div>
                    </div>
                  </a-card>
                </div>
              </div>
            </div>

            <div v-if="selectedMenuKey[0] === 'problems'" class="content-panel">
              <div class="panel-header">
                <h2>行业问题关联</h2>
                <p>企业可能面临的行业痛点和问题</p>
              </div>
              <div class="panel-content">
                <div class="problems-list">
                  <a-card 
                    v-for="problem in enterpriseInfo.industryProblems" 
                    :key="problem.id"
                    class="problem-card"
                    :bordered="false"
                  >
                    <template #title>
                      <div class="problem-header">
                        <h3 class="problem-name">{{ problem.name }}</h3>
                        <div class="problem-badges">
                          <a-tag :color="getProblemTypeColor(problem.type)">{{ problem.type }}</a-tag>
                          <a-tag :color="getSeverityColor(problem.severity)">{{ problem.severity }}风险</a-tag>
                        </div>
                      </div>
                    </template>
                    
                    <div class="problem-content">
                      <div class="problem-description">
                        <h4>问题描述</h4>
                        <p>{{ problem.description }}</p>
                      </div>
                      
                      <div class="problem-impact">
                        <h4>影响分析</h4>
                        <p>{{ problem.impact }}</p>
                      </div>
                      
                      <div class="problem-solutions">
                        <h4>解决方案</h4>
                        <ul class="solution-list">
                          <li v-for="solution in problem.solutions" :key="solution">
                            {{ solution }}
                          </li>
                        </ul>
                      </div>
                      
                      <div v-if="problem.relatedStandards.length > 0" class="related-standards">
                        <h4>相关标准</h4>
                        <div class="standard-tags">
                          <a-tag v-for="standard in problem.relatedStandards" :key="standard" color="blue">
                            {{ standard }}
                          </a-tag>
                        </div>
                      </div>
                    </div>
                  </a-card>
                </div>
              </div>
            </div>

            <div v-if="selectedMenuKey[0] === 'policies'" class="content-panel">
              <div class="panel-header">
                <h2>适配政策</h2>
                <p>企业可申报或享受的政策信息</p>
              </div>
              <div class="panel-content">
                <div class="policies-list">
                  <a-card 
                    v-for="policy in enterpriseInfo.applicablePolicies" 
                    :key="policy.id"
                    class="policy-card"
                    :bordered="false"
                  >
                    <template #title>
                      <div class="policy-header">
                        <h3 class="policy-name">{{ policy.name }}</h3>
                        <div class="policy-badges">
                          <a-tag :color="getPolicyTypeColor(policy.type)">{{ policy.type }}</a-tag>
                          <a-tag color="blue">{{ policy.publisher }}</a-tag>
                        </div>
                      </div>
                    </template>
                    
                    <div class="policy-content">
                      <a-descriptions :column="2" size="small">
                        <a-descriptions-item label="发布时间">{{ policy.publishDate }}</a-descriptions-item>
                        <a-descriptions-item label="生效时间">{{ policy.effectiveDate }}</a-descriptions-item>
                        <a-descriptions-item label="适用范围">{{ policy.applicableScope }}</a-descriptions-item>
                        <a-descriptions-item label="申请截止">{{ policy.applicationDeadline }}</a-descriptions-item>
                        <a-descriptions-item label="联系方式" :span="2">{{ policy.contactInfo }}</a-descriptions-item>
                      </a-descriptions>
                      
                      <div class="policy-benefits">
                        <h4>政策优惠</h4>
                        <ul class="benefit-list">
                          <li v-for="benefit in policy.benefits" :key="benefit">
                            <CheckCircleOutlined class="benefit-icon" />
                            {{ benefit }}
                          </li>
                        </ul>
                      </div>
                      
                      <div class="policy-requirements">
                        <h4>申请条件</h4>
                        <ul class="requirement-list">
                          <li v-for="requirement in policy.requirements" :key="requirement">
                            <ExclamationCircleOutlined class="requirement-icon" />
                            {{ requirement }}
                          </li>
                        </ul>
                      </div>
                    </div>
                  </a-card>
                </div>
              </div>
            </div>

            <div v-if="selectedMenuKey[0] === 'bidding'" class="content-panel">
              <div class="panel-header">
                <h2>招投标信息</h2>
                <p>企业历史的招标和中标信息</p>
              </div>
              <div class="panel-content">
                <div class="bidding-list">
                  <a-card 
                    v-for="bidding in enterpriseInfo.biddingInfo" 
                    :key="bidding.id"
                    class="bidding-card"
                    :bordered="false"
                  >
                    <template #title>
                      <div class="bidding-header">
                        <h3 class="bidding-title">{{ bidding.title }}</h3>
                        <div class="bidding-badges">
                          <a-tag :color="getBiddingTypeColor(bidding.type)">{{ bidding.type }}</a-tag>
                          <a-tag :color="getBiddingStatusColor(bidding.status)">{{ bidding.status }}</a-tag>
                          <a-tag color="red">{{ bidding.amount }}</a-tag>
                        </div>
                      </div>
                    </template>
                    
                    <div class="bidding-content">
                      <a-descriptions :column="2" size="small">
                        <a-descriptions-item label="项目日期">{{ bidding.date }}</a-descriptions-item>
                        <a-descriptions-item label="项目金额">{{ bidding.amount }}</a-descriptions-item>
                        <a-descriptions-item label="项目状态">{{ bidding.status }}</a-descriptions-item>
                        <a-descriptions-item label="中标原因">{{ bidding.winReason }}</a-descriptions-item>
                      </a-descriptions>
                      
                      <div class="bidding-description">
                        <h4>项目描述</h4>
                        <p>{{ bidding.description }}</p>
                      </div>
                      
                      <div class="bidding-requirements">
                        <h4>技术要求</h4>
                        <ul class="requirement-list">
                          <li v-for="requirement in bidding.requirements" :key="requirement">
                            <CheckCircleOutlined class="requirement-icon" />
                            {{ requirement }}
                          </li>
                        </ul>
                      </div>
                      
                      <div class="bidding-competitors">
                        <h4>竞争对手</h4>
                        <div class="competitor-tags">
                          <a-tag v-for="competitor in bidding.competitors" :key="competitor" color="orange">
                            {{ competitor }}
                          </a-tag>
                        </div>
                      </div>
                    </div>
                  </a-card>
                </div>
              </div>
            </div>

            <div v-if="selectedMenuKey[0] === 'talents'" class="content-panel">
              <div class="panel-header">
                <h2>人才信息</h2>
                <p>企业关键负责人和核心人才信息</p>
              </div>
              <div class="panel-content">
                <div class="talents-list">
                  <a-card 
                    v-for="talent in enterpriseInfo.talentInfo" 
                    :key="talent.id"
                    class="talent-card"
                    :bordered="false"
                  >
                    <template #title>
                      <div class="talent-header">
                        <div class="talent-avatar">
                          <a-avatar :size="48" style="background-color: #1890ff">
                            {{ talent.name.charAt(0) }}
                          </a-avatar>
                        </div>
                        <div class="talent-basic">
                          <h3 class="talent-name">{{ talent.name }}</h3>
                          <p class="talent-position">{{ talent.position }} · {{ talent.department }}</p>
                        </div>
                        <div class="talent-badges">
                          <a-tag :color="getTalentLevelColor(talent.level)">{{ talent.level }}</a-tag>
                          <a-tag color="blue">{{ talent.experience }}经验</a-tag>
                        </div>
                      </div>
                    </template>
                    
                    <div class="talent-content">
                      <a-descriptions :column="2" size="small">
                        <a-descriptions-item label="学历">{{ talent.education }}</a-descriptions-item>
                        <a-descriptions-item label="专业">{{ talent.major }}</a-descriptions-item>
                        <a-descriptions-item label="工作经验">{{ talent.experience }}</a-descriptions-item>
                        <a-descriptions-item label="邮箱">{{ talent.contactInfo.email }}</a-descriptions-item>
                        <a-descriptions-item label="电话">{{ talent.contactInfo.phone }}</a-descriptions-item>
                      </a-descriptions>
                      
                      <div class="talent-skills">
                        <h4>核心技能</h4>
                        <div class="skill-tags">
                          <a-tag v-for="skill in talent.skills" :key="skill" color="green">
                            {{ skill }}
                          </a-tag>
                        </div>
                      </div>
                      
                      <div class="talent-achievements">
                        <h4>主要成就</h4>
                        <ul class="achievement-list">
                          <li v-for="achievement in talent.achievements" :key="achievement">
                            <TrophyOutlined class="achievement-icon" />
                            {{ achievement }}
                          </li>
                        </ul>
                      </div>
                    </div>
                  </a-card>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- AI交互弹窗 -->
    <AIDialog 
      :dialog-type="'enterprise'"
      :default-expanded="true"
      @toggle="handleAIDialogToggle"
      @send-message="handleAIMessage"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Header from '@/components/Header.vue'
import AIDialog from '@/components/AIDialog.vue'
import {
  BankOutlined,
  AppstoreOutlined,
  TrophyOutlined,
  NodeIndexOutlined,
  GlobalOutlined,
  FileTextOutlined,
  SolutionOutlined,
  QuestionCircleOutlined,
  FileProtectOutlined,
  AuditOutlined,
  TeamOutlined,
  CheckCircleOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons-vue'

const route = useRoute()
const router = useRouter()
const selectedMenuKey = ref(['basic'])

// 企业信息数据
const enterpriseInfo = ref({
  id: 1,
  name: '宁德时代新能源科技股份有限公司',
  logo: '/api/placeholder/120/120',
  creditCode: '91350900MA2Y5K3X1A',
  registeredCapital: '232,947.00万人民币',
  establishmentDate: '2011-12-16',
  legalPerson: '曾毓群',
  status: '在营(开业)',
  location: '福建省宁德市',
  tags: ['在营(开业)', '上市企业', '中国500强', '高新技术企业', '民营500强', '世界500强'],
  chainPosition: '中游制造',
  
  // 股东信息
  shareholders: [
    { id: 1, name: '曾毓群', type: '自然人', shareholding: '24.43%', amount: '56,890.00万' },
    { id: 2, name: '黄世霖', type: '自然人', shareholding: '11.20%', amount: '26,090.00万' },
    { id: 3, name: '李平', type: '自然人', shareholding: '5.25%', amount: '12,230.00万' }
  ],
  
  // 主要人员
  personnel: [
    { id: 1, name: '曾毓群', position: '董事长', type: '执行董事' },
    { id: 2, name: '黄世霖', position: '副董事长', type: '执行董事' },
    { id: 3, name: '李平', position: '董事', type: '执行董事' },
    { id: 4, name: '周佳', position: '总经理', type: '高级管理人员' }
  ],
  
  // 分支机构
  branches: [
    { id: 1, name: '宁德时代新能源科技股份有限公司上海分公司', location: '上海市', status: '存续' },
    { id: 2, name: '宁德时代新能源科技股份有限公司深圳分公司', location: '深圳市', status: '存续' }
  ],
  
  // 变更记录
  changes: [
    { id: 1, date: '2023-12-15', type: '注册资本变更', content: '注册资本从220,000.00万变更为232,947.00万' },
    { id: 2, date: '2023-08-20', type: '经营范围变更', content: '新增新能源汽车充电设施运营业务' },
    { id: 3, date: '2023-05-10', type: '法定代表人变更', content: '法定代表人变更为曾毓群' }
  ],
  
  // 产品信息
  products: [
    {
      id: 1,
      name: '动力电池系统',
      type: '核心产品',
      description: '为新能源汽车提供高性能、高安全性的动力电池系统解决方案',
      features: ['高能量密度', '长循环寿命', '快充技术', '安全防护'],
      applications: ['纯电动汽车', '混合动力汽车', '储能系统']
    },
    {
      id: 2,
      name: '储能系统',
      type: '核心产品',
      description: '为电网储能、工商业储能提供完整的储能系统解决方案',
      features: ['模块化设计', '智能管理', '高安全性', '长寿命'],
      applications: ['电网储能', '工商业储能', '家庭储能']
    }
  ],
  
  // 荣誉信息
  honors: [
    {
      id: 1,
      name: '国家高新技术企业',
      description: '在新能源电池技术领域具有突出的技术创新能力',
      date: '2020-12-01',
      issuer: '国家科技部',
      icon: TrophyOutlined
    },
    {
      id: 2,
      name: '专精特新小巨人企业',
      description: '在动力电池细分领域具有专业化、精细化、特色化、新颖化特征',
      date: '2021-08-15',
      issuer: '工业和信息化部',
      icon: TrophyOutlined
    }
  ],
  
  // 上下游企业
  upstreamCompanies: [
    { id: 1, name: '赣锋锂业', relationship: '锂资源供应商' },
    { id: 2, name: '天齐锂业', relationship: '锂化合物供应商' },
    { id: 3, name: '华友钴业', relationship: '钴材料供应商' }
  ],
  
  downstreamCompanies: [
    { id: 1, name: '特斯拉', relationship: '动力电池客户' },
    { id: 2, name: '蔚来汽车', relationship: '动力电池客户' },
    { id: 3, name: '理想汽车', relationship: '动力电池客户' }
  ],

  // 适配行业标准
  industryStandards: [
    {
      id: 1,
      name: 'GB/T 31485-2015 电动汽车用动力蓄电池安全要求及试验方法',
      type: '国家标准',
      category: '安全标准',
      status: '现行',
      applicableScope: '动力电池安全测试',
      description: '规定了电动汽车用动力蓄电池的安全要求、试验方法和检验规则',
      relatedProducts: ['动力电池系统', '储能系统']
    },
    {
      id: 2,
      name: 'GB/T 31467.1-2015 电动汽车用锂离子动力蓄电池包和系统 第1部分：高功率应用测试规程',
      type: '国家标准',
      category: '测试标准',
      status: '现行',
      applicableScope: '高功率动力电池测试',
      description: '规定了电动汽车用锂离子动力蓄电池包和系统高功率应用的测试规程',
      relatedProducts: ['动力电池系统']
    },
    {
      id: 3,
      name: 'IEC 62619-2017 工业用二次锂电池和电池组安全要求',
      type: '国际标准',
      category: '安全标准',
      status: '现行',
      applicableScope: '工业储能电池安全',
      description: '规定了工业用二次锂电池和电池组的安全要求和测试方法',
      relatedProducts: ['储能系统']
    }
  ],

  // 适配行业方案
  industrySolutions: [
    {
      id: 1,
      name: '新能源汽车动力电池解决方案',
      type: '信息化方案',
      industry: '新能源汽车',
      description: '为新能源汽车制造商提供完整的动力电池系统解决方案，包括电池管理、热管理、安全监控等',
      features: ['智能电池管理', '热管理系统', '安全监控', '远程诊断'],
      applications: ['纯电动汽车', '混合动力汽车', '插电式混合动力汽车'],
      implementationPeriod: '6-12个月',
      investment: '500-2000万',
      successCases: ['特斯拉Model 3', '蔚来ES8', '理想ONE']
    },
    {
      id: 2,
      name: '电网储能系统解决方案',
      type: '智能化方案',
      industry: '电力能源',
      description: '为电网公司提供大规模储能系统解决方案，支持削峰填谷、调频调峰等应用',
      features: ['智能调度', '远程监控', '故障预警', '数据分析'],
      applications: ['电网储能', '新能源并网', '调频调峰'],
      implementationPeriod: '12-18个月',
      investment: '1000-5000万',
      successCases: ['国家电网储能项目', '南方电网储能项目']
    }
  ],

  // 行业问题关联
  industryProblems: [
    {
      id: 1,
      name: '动力电池安全性问题',
      type: '安全问题',
      severity: '高',
      description: '动力电池在极端条件下可能出现热失控、起火等安全问题',
      impact: '影响产品安全性和市场接受度',
      solutions: [
        '采用先进的热管理系统',
        '实施严格的安全测试标准',
        '建立完善的监控预警机制'
      ],
      relatedStandards: ['GB/T 31485-2015', 'IEC 62619-2017']
    },
    {
      id: 2,
      name: '电池回收利用问题',
      type: '环保问题',
      severity: '中',
      description: '动力电池退役后的回收利用技术不成熟，环保压力大',
      impact: '影响企业环保形象和可持续发展',
      solutions: [
        '建立电池回收体系',
        '开发电池梯次利用技术',
        '与回收企业建立合作关系'
      ],
      relatedStandards: ['GB/T 34015-2017']
    },
    {
      id: 3,
      name: '电池成本控制问题',
      type: '成本问题',
      severity: '高',
      description: '动力电池成本较高，影响新能源汽车的普及',
      impact: '影响产品竞争力和市场推广',
      solutions: [
        '优化电池设计降低成本',
        '提高生产效率',
        '规模化生产降低成本'
      ],
      relatedStandards: []
    }
  ],

  // 适配政策
  applicablePolicies: [
    {
      id: 1,
      name: '新能源汽车产业发展规划（2021-2035年）',
      type: '国家政策',
      publisher: '国务院',
      publishDate: '2020-11-02',
      effectiveDate: '2021-01-01',
      applicableScope: '新能源汽车产业',
      benefits: [
        '新能源汽车购置补贴',
        '充电基础设施建设支持',
        '技术创新资金支持'
      ],
      requirements: [
        '符合新能源汽车技术标准',
        '具备相关技术研发能力',
        '通过相关认证'
      ],
      applicationDeadline: '2025-12-31',
      contactInfo: '工业和信息化部装备工业司'
    },
    {
      id: 2,
      name: '关于完善新能源汽车推广应用财政补贴政策的通知',
      type: '财政政策',
      publisher: '财政部、工业和信息化部',
      publishDate: '2023-12-31',
      effectiveDate: '2024-01-01',
      applicableScope: '新能源汽车推广应用',
      benefits: [
        '新能源汽车购置补贴',
        '充电设施建设补贴',
        '运营补贴'
      ],
      requirements: [
        '车辆符合技术标准',
        '通过相关检测认证',
        '在指定地区推广应用'
      ],
      applicationDeadline: '2024-12-31',
      contactInfo: '财政部经济建设司'
    },
    {
      id: 3,
      name: '福建省新能源汽车产业发展行动计划',
      type: '地方政策',
      publisher: '福建省人民政府',
      publishDate: '2023-06-15',
      effectiveDate: '2023-07-01',
      applicableScope: '福建省新能源汽车产业',
      benefits: [
        '地方财政补贴',
        '土地政策支持',
        '人才引进支持'
      ],
      requirements: [
        '在福建省注册企业',
        '符合产业发展方向',
        '达到相关技术指标'
      ],
      applicationDeadline: '2025-12-31',
      contactInfo: '福建省工业和信息化厅'
    }
  ],

  // 招投标信息
  biddingInfo: [
    {
      id: 1,
      title: '某汽车制造商动力电池系统采购项目',
      type: '中标',
      amount: '2.5亿元',
      date: '2024-01-15',
      status: '已完成',
      description: '为某知名汽车制造商提供动力电池系统，包括电池包、BMS等',
      requirements: [
        '电池能量密度≥180Wh/kg',
        '循环寿命≥2000次',
        '安全等级达到GB/T 31485要求'
      ],
      competitors: ['比亚迪', '国轩高科', '亿纬锂能'],
      winReason: '技术指标领先，成本控制优秀'
    },
    {
      id: 2,
      title: '国家电网储能系统建设项目',
      type: '中标',
      amount: '1.8亿元',
      date: '2023-11-20',
      status: '实施中',
      description: '为国家电网提供大规模储能系统，用于电网调峰调频',
      requirements: [
        '系统容量≥100MWh',
        '充放电效率≥90%',
        '系统寿命≥15年'
      ],
      competitors: ['阳光电源', '科华数据', '南都电源'],
      winReason: '技术方案先进，项目经验丰富'
    },
    {
      id: 3,
      title: '某城市公交电动化改造项目',
      type: '招标',
      amount: '8000万元',
      date: '2024-02-01',
      status: '投标中',
      description: '为某城市公交系统提供动力电池系统，支持公交电动化改造',
      requirements: [
        '电池容量≥200Ah',
        '快充能力≥2C',
        '环境适应性-30°C~60°C'
      ],
      competitors: ['比亚迪', '宇通客车', '中通客车'],
      winReason: '待开标'
    }
  ],

  // 人才信息
  talentInfo: [
    {
      id: 1,
      name: '曾毓群',
      position: '董事长',
      department: '董事会',
      level: '高级管理',
      experience: '20年',
      education: '博士',
      major: '材料科学与工程',
      skills: ['战略规划', '技术管理', '团队领导', '市场开拓'],
      achievements: [
        '带领公司成为全球动力电池龙头企业',
        '获得多项技术专利',
        '推动公司成功上市'
      ],
      contactInfo: {
        email: 'zengyuqun@catl.com',
        phone: '0593-2758888'
      }
    },
    {
      id: 2,
      name: '黄世霖',
      position: '副董事长',
      department: '董事会',
      level: '高级管理',
      experience: '18年',
      education: '硕士',
      major: '电气工程',
      skills: ['技术研发', '产品管理', '质量控制', '项目管理'],
      achievements: [
        '主导多项核心技术研发',
        '建立完善的质量管理体系',
        '推动产品技术升级'
      ],
      contactInfo: {
        email: 'huangshilin@catl.com',
        phone: '0593-2758889'
      }
    },
    {
      id: 3,
      name: '周佳',
      position: '总经理',
      department: '经营管理',
      level: '高级管理',
      experience: '15年',
      education: '硕士',
      major: '工商管理',
      skills: ['经营管理', '市场拓展', '客户关系', '团队管理'],
      achievements: [
        '推动公司业务快速发展',
        '建立完善的客户服务体系',
        '实现业绩持续增长'
      ],
      contactInfo: {
        email: 'zhoujia@catl.com',
        phone: '0593-2758890'
      }
    },
    {
      id: 4,
      name: '张博士',
      position: '首席技术官',
      department: '技术研发',
      level: '技术专家',
      experience: '12年',
      education: '博士',
      major: '电化学',
      skills: ['电池技术', '材料研发', '工艺优化', '技术创新'],
      achievements: [
        '获得50+项技术专利',
        '发表20+篇学术论文',
        '主导多项重大技术突破'
      ],
      contactInfo: {
        email: 'zhang@catl.com',
        phone: '0593-2758891'
      }
    }
  ]
})

// 表格列定义
const shareholderColumns = [
  { title: '股东名称', dataIndex: 'name', key: 'name' },
  { title: '股东类型', dataIndex: 'type', key: 'type' },
  { title: '持股比例', dataIndex: 'shareholding', key: 'shareholding' },
  { title: '认缴出资额', dataIndex: 'amount', key: 'amount' }
]

const personnelColumns = [
  { title: '姓名', dataIndex: 'name', key: 'name' },
  { title: '职务', dataIndex: 'position', key: 'position' },
  { title: '类型', dataIndex: 'type', key: 'type' }
]

const branchColumns = [
  { title: '分支机构名称', dataIndex: 'name', key: 'name' },
  { title: '所在地', dataIndex: 'location', key: 'location' },
  { title: '状态', dataIndex: 'status', key: 'status' }
]

// 方法
const handleMenuClick = ({ key }) => {
  selectedMenuKey.value = [key]
}

const handleImageError = (event) => {
  // 防止无限循环，如果已经是占位图片就不再处理
  if (event.target.src.includes('data:image') || event.target.src.includes('placeholder')) {
    return
  }
  
  // 使用base64编码的占位图片
  event.target.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIwIiBoZWlnaHQ9IjEyMCIgdmlld0JveD0iMCAwIDEyMCAxMjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIxMjAiIGhlaWdodD0iMTIwIiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik02MCA0MEM2Ni42MjcgNDAgNzIgNDUuMzcyIDcyIDUyQzcyIDU4LjYyNyA2Ni42MjcgNjQgNjAgNjRDNTMuMzcyIDY0IDQ4IDU4LjYyNyA0OCA1MkM0OCA0NS4zNzIgNTMuMzcyIDQwIDYwIDQwWiIgZmlsbD0iI0NDQ0NDQyIvPgo8cGF0aCBkPSJNNDggODhDNDggODEuMzcyIDUzLjM3MiA3NiA2MCA3NkM2Ni42MjcgNzYgNzIgODEuMzcyIDcyIDg4VjkySDQ4Vjg4WiIgZmlsbD0iI0NDQ0NDQyIvPgo8L3N2Zz4K'
}

const getTagColor = (tag) => {
  const colorMap = {
    '在营(开业)': 'green',
    '上市企业': 'blue',
    '中国500强': 'red',
    '高新技术企业': 'orange',
    '民营500强': 'purple',
    '世界500强': 'gold'
  }
  return colorMap[tag] || 'default'
}

// 标准类型颜色
const getStandardTypeColor = (type) => {
  const colorMap = {
    '国家标准': 'red',
    '国际标准': 'blue',
    '行业标准': 'green',
    '地方标准': 'orange'
  }
  return colorMap[type] || 'default'
}

// 标准分类颜色
const getStandardCategoryColor = (category) => {
  const colorMap = {
    '安全标准': 'red',
    '测试标准': 'blue',
    '质量标准': 'green',
    '技术标准': 'purple'
  }
  return colorMap[category] || 'default'
}

// 方案类型颜色
const getSolutionTypeColor = (type) => {
  const colorMap = {
    '信息化方案': 'blue',
    '智能化方案': 'purple',
    '数字化方案': 'green',
    '自动化方案': 'orange'
  }
  return colorMap[type] || 'default'
}

// 问题类型颜色
const getProblemTypeColor = (type) => {
  const colorMap = {
    '安全问题': 'red',
    '环保问题': 'green',
    '成本问题': 'orange',
    '技术问题': 'blue',
    '市场问题': 'purple'
  }
  return colorMap[type] || 'default'
}

// 严重程度颜色
const getSeverityColor = (severity) => {
  const colorMap = {
    '高': 'red',
    '中': 'orange',
    '低': 'green'
  }
  return colorMap[severity] || 'default'
}

// 政策类型颜色
const getPolicyTypeColor = (type) => {
  const colorMap = {
    '国家政策': 'red',
    '地方政策': 'blue',
    '财政政策': 'green',
    '产业政策': 'purple'
  }
  return colorMap[type] || 'default'
}

// 招投标类型颜色
const getBiddingTypeColor = (type) => {
  const colorMap = {
    '中标': 'green',
    '招标': 'blue',
    '投标': 'orange'
  }
  return colorMap[type] || 'default'
}

// 招投标状态颜色
const getBiddingStatusColor = (status) => {
  const colorMap = {
    '已完成': 'green',
    '实施中': 'blue',
    '投标中': 'orange',
    '已中标': 'green',
    '未中标': 'red'
  }
  return colorMap[status] || 'default'
}

// 人才级别颜色
const getTalentLevelColor = (level) => {
  const colorMap = {
    '高级管理': 'red',
    '中级管理': 'orange',
    '技术专家': 'blue',
    '高级工程师': 'green',
    '工程师': 'cyan'
  }
  return colorMap[level] || 'default'
}

const getStatusColor = (status) => {
  return status === '在营(开业)' ? 'green' : 'red'
}

const getChangeColor = (type) => {
  const colorMap = {
    '注册资本变更': 'blue',
    '经营范围变更': 'green',
    '法定代表人变更': 'orange'
  }
  return colorMap[type] || 'default'
}

const getProductTypeColor = (type) => {
  return type === '核心产品' ? 'red' : 'blue'
}

// AI对话框处理函数
const handleAIDialogToggle = (isExpanded) => {
  console.log('AI对话框状态:', isExpanded ? '展开' : '收起')
}

const handleAIMessage = (message) => {
  console.log('AI消息:', message)
  // 这里可以添加AI消息处理逻辑
}

onMounted(() => {
  // 从路由参数获取企业ID，加载对应企业信息
  const enterpriseId = route.params.id
  console.log('加载企业详情:', enterpriseId)
})
</script>

<style lang="scss" scoped>
.enterprise-detail {
  min-height: 100vh;
  background: $bg-secondary;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 $spacing-lg;
}

// 企业头部信息
.enterprise-header {
  background: $bg-primary;
  border-bottom: 1px solid $border-light;
  padding: $spacing-xl 0;
}

.header-content {
  display: flex;
  gap: $spacing-xl;
  align-items: flex-start;
}

.enterprise-logo {
  flex-shrink: 0;
  width: 120px;
  height: 120px;
  
  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: $border-radius-lg;
    border: 1px solid $border-light;
  }
}

.enterprise-basic {
  flex: 1;
}

.enterprise-name {
  font-size: $font-size-xxxl;
  font-weight: 700;
  color: $text-primary;
  margin-bottom: $spacing-md;
}

.enterprise-tags {
  display: flex;
  flex-wrap: wrap;
  gap: $spacing-xs;
  margin-bottom: $spacing-lg;
}

.enterprise-tag {
  margin: 0;
}

.basic-info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: $spacing-md;
}

.info-item {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  
  .info-label {
    font-size: $font-size-sm;
    color: $text-secondary;
    min-width: 120px;
  }
  
  .info-value {
    font-size: $font-size-sm;
    color: $text-primary;
  }
}

// 主要内容区域
.main-content {
  padding: $spacing-xl 0;
}

.content-layout {
  display: grid;
  grid-template-columns: 250px 1fr;
  gap: $spacing-xl;
  min-height: 600px;
}

// 左侧菜单栏
.sidebar {
  background: $bg-primary;
  border-radius: $border-radius-lg;
  padding: $spacing-lg;
  box-shadow: $box-shadow;
  height: fit-content;
  position: sticky;
  top: 100px;
}

.sidebar-menu {
  border: none;
  background: transparent;
  
  :deep(.ant-menu-item) {
    color: $text-secondary;
    border-radius: $border-radius;
    margin-bottom: $spacing-xs;
    
    &:hover {
      color: $primary-color;
      background: rgba($primary-color, 0.1);
    }
    
    &.ant-menu-item-selected {
      color: $primary-color;
      background: rgba($primary-color, 0.1);
      border-right: 3px solid $primary-color;
    }
  }
}

// 右侧内容区域
.content-area {
  background: $bg-primary;
  border-radius: $border-radius-lg;
  box-shadow: $box-shadow;
  overflow: hidden;
}

.content-panel {
  padding: $spacing-xl;
}

.panel-header {
  margin-bottom: $spacing-xl;
  padding-bottom: $spacing-lg;
  border-bottom: 1px solid $border-light;
  
  h2 {
    font-size: $font-size-xxl;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-sm;
  }
  
  p {
    color: $text-secondary;
    margin: 0;
  }
}

.panel-content {
  .info-section {
    margin-bottom: $spacing-xl;
    
    h3 {
      font-size: $font-size-lg;
      font-weight: 600;
      color: $text-primary;
      margin-bottom: $spacing-md;
    }
  }
}

// 变更记录
.change-item {
  .change-header {
    display: flex;
    align-items: center;
    gap: $spacing-md;
    margin-bottom: $spacing-xs;
    
    .change-date {
      font-size: $font-size-sm;
      color: $text-secondary;
    }
  }
  
  .change-content {
    color: $text-primary;
    font-size: $font-size-sm;
  }
}

// 产品卡片
.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: $spacing-lg;
}

.product-card {
  background: $bg-secondary;
  border-radius: $border-radius-lg;
  padding: $spacing-lg;
  border: 1px solid $border-light;
  
  .product-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: $spacing-md;
    
    h3 {
      font-size: $font-size-lg;
      font-weight: 600;
      color: $text-primary;
      margin: 0;
    }
  }
  
  .product-description {
    color: $text-secondary;
    line-height: 1.6;
    margin-bottom: $spacing-md;
  }
  
  .product-features,
  .product-applications {
    margin-bottom: $spacing-md;
    
    h4 {
      font-size: $font-size-md;
      font-weight: 600;
      color: $text-primary;
      margin-bottom: $spacing-sm;
    }
  }
  
  .features-list,
  .applications-list {
    display: flex;
    flex-wrap: wrap;
    gap: $spacing-xs;
  }
  
  .feature-tag {
    margin: 0;
  }
}

// 荣誉卡片
.honors-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: $spacing-lg;
}

.honor-card {
  background: $bg-secondary;
  border-radius: $border-radius-lg;
  padding: $spacing-lg;
  border: 1px solid $border-light;
  display: flex;
  gap: $spacing-md;
  
  .honor-icon {
    flex-shrink: 0;
    width: 50px;
    height: 50px;
    background: $bg-gradient;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: $text-white;
    font-size: 20px;
  }
  
  .honor-content {
    flex: 1;
    
    h3 {
      font-size: $font-size-lg;
      font-weight: 600;
      color: $text-primary;
      margin-bottom: $spacing-sm;
    }
    
    p {
      color: $text-secondary;
      line-height: 1.6;
      margin-bottom: $spacing-md;
    }
    
    .honor-meta {
      display: flex;
      flex-direction: column;
      gap: $spacing-xs;
      
      span {
        font-size: $font-size-sm;
        color: $text-secondary;
      }
    }
  }
}

// 产业链可视化
.industry-chain-visual {
  .chain-flow {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: $spacing-xl;
    padding: $spacing-xl;
    background: $bg-secondary;
    border-radius: $border-radius-lg;
    border: 1px solid $border-light;
  }
  
  .chain-node {
    flex: 1;
    text-align: center;
    
    h4 {
      font-size: $font-size-lg;
      font-weight: 600;
      color: $text-primary;
      margin-bottom: $spacing-md;
    }
    
    &.upstream {
      .company-list {
        .company-item {
          background: rgba($primary-color, 0.1);
          border: 1px solid $primary-color;
        }
      }
    }
    
    &.current {
      .current-company {
        background: $bg-gradient;
        color: $text-white;
        padding: $spacing-lg;
        border-radius: $border-radius-lg;
        
        strong {
          display: block;
          font-size: $font-size-lg;
          margin-bottom: $spacing-xs;
        }
        
        .position {
          font-size: $font-size-sm;
          opacity: 0.9;
        }
      }
    }
    
    &.downstream {
      .company-list {
        .company-item {
          background: rgba($accent-color, 0.1);
          border: 1px solid $accent-color;
        }
      }
    }
  }
  
  .company-list {
    display: flex;
    flex-direction: column;
    gap: $spacing-sm;
  }
  
  .company-item {
    padding: $spacing-sm;
    border-radius: $border-radius;
    
    .company-name {
      display: block;
      font-weight: 500;
      color: $text-primary;
      margin-bottom: $spacing-xs;
    }
    
    .relationship {
      font-size: $font-size-sm;
      color: $text-secondary;
    }
  }
}

// 响应式设计
@media (max-width: $breakpoint-lg) {
  .content-layout {
    grid-template-columns: 1fr;
    gap: $spacing-lg;
  }
  
  .sidebar {
    position: static;
    order: 2;
  }
  
  .content-area {
    order: 1;
  }
  
  .header-content {
    flex-direction: column;
    text-align: center;
  }
  
  .basic-info-grid {
    grid-template-columns: 1fr;
  }
  
  .products-grid {
    grid-template-columns: 1fr;
  }
  
  .honors-grid {
    grid-template-columns: 1fr;
  }
  
  .chain-flow {
    flex-direction: column !important;
    gap: $spacing-lg !important;
  }
}

@media (max-width: $breakpoint-md) {
  .enterprise-name {
    font-size: $font-size-xxl !important;
  }
  
  .content-panel {
    padding: $spacing-lg;
  }
  
  .honor-card {
    flex-direction: column;
    text-align: center;
  }
}

// 标准卡片样式
.standards-list {
  .standard-card {
    margin-bottom: 16px;
    
    .standard-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      
      .standard-name {
        font-size: 16px;
        font-weight: 600;
        color: $text-primary;
        margin: 0;
        flex: 1;
        margin-right: 16px;
      }
      
      .standard-badges {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
    }
    
    .standard-content {
      .standard-description {
        margin-top: 16px;
        
        h4 {
          font-size: 14px;
          font-weight: 600;
          color: $text-primary;
          margin-bottom: 8px;
        }
        
        p {
          color: $text-secondary;
          line-height: 1.6;
          margin: 0;
        }
      }
    }
  }
}

// 方案卡片样式
.solutions-list {
  .solution-card {
    margin-bottom: 16px;
    
    .solution-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      
      .solution-name {
        font-size: 16px;
        font-weight: 600;
        color: $text-primary;
        margin: 0;
        flex: 1;
        margin-right: 16px;
      }
      
      .solution-badges {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
    }
    
    .solution-content {
      .solution-description,
      .solution-features,
      .solution-applications,
      .solution-cases {
        margin-top: 16px;
        
        h4 {
          font-size: 14px;
          font-weight: 600;
          color: $text-primary;
          margin-bottom: 8px;
        }
        
        p {
          color: $text-secondary;
          line-height: 1.6;
          margin: 0;
        }
        
        .feature-tags,
        .application-tags,
        .case-tags {
          display: flex;
          gap: 8px;
          flex-wrap: wrap;
        }
      }
    }
  }
}

// 问题卡片样式
.problems-list {
  .problem-card {
    margin-bottom: 16px;
    
    .problem-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      
      .problem-name {
        font-size: 16px;
        font-weight: 600;
        color: $text-primary;
        margin: 0;
        flex: 1;
        margin-right: 16px;
      }
      
      .problem-badges {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
    }
    
    .problem-content {
      .problem-description,
      .problem-impact,
      .problem-solutions,
      .related-standards {
        margin-top: 16px;
        
        h4 {
          font-size: 14px;
          font-weight: 600;
          color: $text-primary;
          margin-bottom: 8px;
        }
        
        p {
          color: $text-secondary;
          line-height: 1.6;
          margin: 0;
        }
        
        .solution-list {
          margin: 0;
          padding-left: 20px;
          
          li {
            color: $text-secondary;
            line-height: 1.6;
            margin-bottom: 4px;
          }
        }
        
        .standard-tags {
          display: flex;
          gap: 8px;
          flex-wrap: wrap;
        }
      }
    }
  }
}

// 政策卡片样式
.policies-list {
  .policy-card {
    margin-bottom: 16px;
    
    .policy-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      
      .policy-name {
        font-size: 16px;
        font-weight: 600;
        color: $text-primary;
        margin: 0;
        flex: 1;
        margin-right: 16px;
      }
      
      .policy-badges {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
    }
    
    .policy-content {
      .policy-benefits,
      .policy-requirements {
        margin-top: 16px;
        
        h4 {
          font-size: 14px;
          font-weight: 600;
          color: $text-primary;
          margin-bottom: 8px;
        }
        
        .benefit-list,
        .requirement-list {
          margin: 0;
          padding-left: 0;
          list-style: none;
          
          li {
            display: flex;
            align-items: center;
            color: $text-secondary;
            line-height: 1.6;
            margin-bottom: 8px;
            
            .benefit-icon {
              color: $success-color;
              margin-right: 8px;
            }
            
            .requirement-icon {
              color: $warning-color;
              margin-right: 8px;
            }
          }
        }
      }
    }
  }
}

// 招投标卡片样式
.bidding-list {
  .bidding-card {
    margin-bottom: 16px;
    
    .bidding-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      
      .bidding-title {
        font-size: 16px;
        font-weight: 600;
        color: $text-primary;
        margin: 0;
        flex: 1;
        margin-right: 16px;
      }
      
      .bidding-badges {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
    }
    
    .bidding-content {
      .bidding-description,
      .bidding-requirements,
      .bidding-competitors {
        margin-top: 16px;
        
        h4 {
          font-size: 14px;
          font-weight: 600;
          color: $text-primary;
          margin-bottom: 8px;
        }
        
        p {
          color: $text-secondary;
          line-height: 1.6;
          margin: 0;
        }
        
        .requirement-list {
          margin: 0;
          padding-left: 0;
          list-style: none;
          
          li {
            display: flex;
            align-items: center;
            color: $text-secondary;
            line-height: 1.6;
            margin-bottom: 8px;
            
            .requirement-icon {
              color: $success-color;
              margin-right: 8px;
            }
          }
        }
        
        .competitor-tags {
          display: flex;
          gap: 8px;
          flex-wrap: wrap;
        }
      }
    }
  }
}

// 人才卡片样式
.talents-list {
  .talent-card {
    margin-bottom: 16px;
    
    .talent-header {
      display: flex;
      align-items: center;
      gap: 16px;
      
      .talent-avatar {
        flex-shrink: 0;
      }
      
      .talent-basic {
        flex: 1;
        
        .talent-name {
          font-size: 16px;
          font-weight: 600;
          color: $text-primary;
          margin: 0 0 4px 0;
        }
        
        .talent-position {
          font-size: 14px;
          color: $text-secondary;
          margin: 0;
        }
      }
      
      .talent-badges {
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
      }
    }
    
    .talent-content {
      .talent-skills,
      .talent-achievements {
        margin-top: 16px;
        
        h4 {
          font-size: 14px;
          font-weight: 600;
          color: $text-primary;
          margin-bottom: 8px;
        }
        
        .skill-tags {
          display: flex;
          gap: 8px;
          flex-wrap: wrap;
        }
        
        .achievement-list {
          margin: 0;
          padding-left: 0;
          list-style: none;
          
          li {
            display: flex;
            align-items: center;
            color: $text-secondary;
            line-height: 1.6;
            margin-bottom: 8px;
            
            .achievement-icon {
              color: $warning-color;
              margin-right: 8px;
            }
          }
        }
      }
    }
  }
}
</style>
