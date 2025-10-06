<template>
  <div class="header">
    <div class="header-container">
      <!-- Logo区域 -->
      <div class="logo-section">
        <div class="logo">
          <div class="logo-icon">
            <SafetyOutlined />
          </div>
          <div class="logo-text">
            <h1>天云产业数据中心</h1>
            <p>TIANYUN INDUSTRY DATA CENTER</p>
          </div>
        </div>
      </div>

      <!-- 导航菜单 -->
      <div class="nav-section">
        <a-menu
          v-model:selectedKeys="selectedKeys"
          mode="horizontal"
          class="nav-menu"
          @click="handleMenuClick"
        >
          <a-menu-item key="home">
            <template #icon>
              <HomeOutlined />
            </template>
            首页
          </a-menu-item>
          <a-menu-item key="enterprise">
            <template #icon>
              <BankOutlined />
            </template>
            企业库
          </a-menu-item>
          <a-menu-item key="solution">
            <template #icon>
              <SolutionOutlined />
            </template>
            方案库
          </a-menu-item>
          <a-menu-item key="knowledge">
            <template #icon>
              <BookOutlined />
            </template>
            知识库
          </a-menu-item>
          <a-menu-item key="talent">
            <template #icon>
              <TeamOutlined />
            </template>
            人才库
          </a-menu-item>
          <a-menu-item key="product">
            <template #icon>
              <AppstoreOutlined />
            </template>
            产品库
          </a-menu-item>
          <a-menu-item key="industry-chain">
            <template #icon>
              <NodeIndexOutlined />
            </template>
            产业链库
          </a-menu-item>
          <a-menu-item key="demand">
            <template #icon>
              <ShoppingCartOutlined />
            </template>
            需求库
          </a-menu-item>
          <a-menu-item key="policy">
            <template #icon>
              <FileTextOutlined />
            </template>
            政策库
          </a-menu-item>
          <a-menu-item key="industry-problem">
            <template #icon>
              <QuestionCircleOutlined />
            </template>
            行业问题库
          </a-menu-item>
        </a-menu>
      </div>

      <!-- 右侧操作区 -->
      <div class="action-section">
        <a-button type="primary" class="member-btn">
          <CrownOutlined />
          开通会员
        </a-button>
        <a-dropdown>
          <a-button type="text" class="user-btn">
            <UserOutlined />
          </a-button>
          <template #overlay>
            <a-menu>
              <a-menu-item key="profile">
                <UserOutlined />
                个人中心
              </a-menu-item>
              <a-menu-item key="settings">
                <SettingOutlined />
                设置
              </a-menu-item>
              <a-menu-divider />
              <a-menu-item key="logout">
                <LogoutOutlined />
                退出登录
              </a-menu-item>
            </a-menu>
          </template>
        </a-dropdown>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import {
  HomeOutlined,
  BankOutlined,
  SolutionOutlined,
  BookOutlined,
  TeamOutlined,
  AppstoreOutlined,
  NodeIndexOutlined,
  ShoppingCartOutlined,
  FileTextOutlined,
  QuestionCircleOutlined,
  SafetyOutlined,
  CrownOutlined,
  UserOutlined,
  SettingOutlined,
  LogoutOutlined,
  MenuOutlined
} from '@ant-design/icons-vue'

const router = useRouter()
const route = useRoute()
const selectedKeys = ref(['home'])

// 监听路由变化，更新选中的菜单项
watch(
  () => route.name,
  (newName) => {
    if (newName === 'Home') {
      selectedKeys.value = ['home']
    } else {
      selectedKeys.value = [newName?.toLowerCase() || 'home']
    }
  },
  { immediate: true }
)

// 菜单点击处理
const handleMenuClick = ({ key }) => {
  if (key === 'home') {
    router.push('/')
  } else {
    router.push(`/${key}`)
  }
}
</script>

<style lang="scss" scoped>
.header {
  background: $bg-primary;
  border-bottom: 1px solid $border-light;
  box-shadow: $box-shadow;
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-container {
  max-width: 1600px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 $spacing-md;
  height: 64px;
}

.logo-section {
  flex-shrink: 0;
}

.logo {
  display: flex;
  align-items: center;
  gap: $spacing-md;
}

.logo-icon {
  width: 40px;
  height: 40px;
  background: $bg-gradient;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: $text-white;
  font-size: 20px;
}

.logo-text {
  h1 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
    line-height: 1.2;
  }
  
  p {
    font-size: 10px;
    color: $text-secondary;
    margin: 0;
    line-height: 1;
  }
}

.nav-section {
  flex: 1;
  display: flex;
  justify-content: center;
  margin: 0 $spacing-md;
  overflow-x: auto;
  scrollbar-width: none;
  -ms-overflow-style: none;
  
  &::-webkit-scrollbar {
    display: none;
  }
}

.nav-menu {
  border: none;
  background: transparent;
  min-width: max-content;
  
  :deep(.ant-menu-item) {
    color: $text-secondary;
    border-bottom: 2px solid transparent;
    padding: 0 8px;
    margin: 0 2px;
    font-size: 13px;
    font-weight: 600;
    white-space: nowrap;
    
    .anticon {
      font-size: 14px;
      margin-right: 4px;
    }
    
    &:hover {
      color: $primary-color;
      border-bottom-color: $primary-color;
    }
    
    &.ant-menu-item-selected {
      color: $primary-color;
      border-bottom-color: $primary-color;
      background: transparent;
    }
    
    // 移除Ant Design默认的下划线
    &::after {
      display: none !important;
    }
  }
}


.action-section {
  display: flex;
  align-items: center;
  gap: $spacing-md;
  flex-shrink: 0;
}

.member-btn {
  background: $accent-color;
  border-color: $accent-color;
  
  &:hover {
    background: $accent-light;
    border-color: $accent-light;
  }
}

.user-btn {
  color: $text-secondary;
  
  &:hover {
    color: $primary-color;
  }
}

// 响应式设计
@media (max-width: $breakpoint-lg) {
  .header-container {
    padding: 0 $spacing-sm;
  }
  
  .nav-section {
    margin: 0 $spacing-sm;
  }
  
  .logo-text {
    h1 {
      font-size: $font-size-sm;
    }
    
    p {
      display: none;
    }
  }
  
  .nav-menu {
    :deep(.ant-menu-item) {
      font-size: 12px;
      padding: 0 6px;
      margin: 0 1px;
      
      .anticon {
        font-size: 12px;
        margin-right: 2px;
      }
      
      // 移除Ant Design默认的下划线
      &::after {
        display: none !important;
      }
    }
  }
}

@media (max-width: $breakpoint-md) {
  .header-container {
    padding: 0 $spacing-xs;
  }
  
  .nav-section {
    margin: 0 $spacing-xs;
  }
  
  .logo-text {
    h1 {
      font-size: 12px;
    }
  }
  
  .nav-menu {
    :deep(.ant-menu-item) {
      font-size: 11px;
      padding: 0 4px;
      margin: 0;
      
      .anticon {
        font-size: 11px;
        margin-right: 1px;
      }
      
      // 移除Ant Design默认的下划线
      &::after {
        display: none !important;
      }
    }
  }
  
  .action-section {
    gap: $spacing-xs;
  }
  
  .member-btn {
    font-size: 12px;
    padding: 4px 8px;
  }
}
</style>
