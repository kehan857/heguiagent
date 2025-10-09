<template>
  <div class="ai-search">
    <!-- 顶部导航 -->
    <Header />
    
    <!-- 主要内容区域 -->
    <div class="ai-search-container">
      <div class="container">
        <div class="ai-search-layout">
          <!-- 左侧AI搜索导航 -->
          <div class="ai-sidebar">
            <div class="ai-logo">
              <div class="ai-icon">
                <div class="asknow-robot">
                  <div class="robot-head"></div>
                  <div class="robot-body"></div>
                  <div class="robot-eye left"></div>
                  <div class="robot-eye right"></div>
                </div>
              </div>
              <h2>AI·搜索</h2>
            </div>
            
            <div class="search-history">
              <h3>搜索历史会话</h3>
              <a-input-search
                v-model:value="searchHistoryQuery"
                placeholder="搜索历史会话"
                size="small"
                class="history-search"
              />
              <div class="history-list">
                <div class="history-item">
                  <ClockCircleOutlined />
                  <span>近7天</span>
                </div>
                <div class="history-item active">
                  <MessageOutlined />
                  <span>新会话</span>
                </div>
              </div>
            </div>
            
            <div class="sidebar-footer">
              <a-button type="link" size="small">查看全部</a-button>
            </div>
          </div>

          <!-- 右侧AI对话区域 -->
          <div class="ai-main-content">
            <div class="ai-chat-container">
              <!-- 初始状态：显示欢迎界面和输入框 -->
              <div v-if="conversationHistory.length === 0" class="welcome-state">
                <!-- AI助手标题 -->
                <div class="ai-chat-header">
                  <div class="ai-avatar-large">
                    <div class="asknow-robot">
                      <div class="robot-head"></div>
                      <div class="robot-body"></div>
                      <div class="robot-eye left"></div>
                      <div class="robot-eye right"></div>
                    </div>
                  </div>
                  <h1>AskNow</h1>
                </div>

              <!-- 搜索输入区域 -->
              <div class="ai-search-input">
                <div class="gemini-input-container">
                  <div class="input-content">
                    <a-textarea
                      v-model:value="searchQuery"
                      placeholder=""
                      class="gemini-textarea"
                      :auto-size="{ minRows: 2, maxRows: 6 }"
                      @pressEnter="handleSearch"
                    />
                    <a-button 
                      type="primary" 
                      class="send-btn"
                      @click="handleSearch"
                      :disabled="!searchQuery.trim()"
                    >
                      <SendOutlined />
                    </a-button>
                  </div>
                </div>
              </div>

              <!-- 8大库关键词内容 -->
              <div class="keywords-section">
                <h3>8大库关键词内容</h3>
                <div class="keywords-grid">
                  <!-- 第一行 -->
                  <div class="keyword-row">
                    <a-button 
                      v-for="keyword in keywordsRow1" 
                      :key="keyword"
                      class="keyword-btn"
                      @click="selectKeyword(keyword)"
                    >
                      {{ keyword }}
                    </a-button>
                  </div>
                  
                  <!-- 第二行 -->
                  <div class="keyword-row">
                    <a-button 
                      v-for="keyword in keywordsRow2" 
                      :key="keyword"
                      class="keyword-btn"
                      @click="selectKeyword(keyword)"
                    >
                      {{ keyword }}
                    </a-button>
                  </div>
                  
                  <!-- 第三行 -->
                  <div class="keyword-row">
                    <a-button 
                      v-for="keyword in keywordsRow3" 
                      :key="keyword"
                      class="keyword-btn"
                      @click="selectKeyword(keyword)"
                    >
                      {{ keyword }}
                    </a-button>
                  </div>
                  
                  <!-- 第四行 -->
                  <div class="keyword-row">
                    <a-button 
                      v-for="keyword in keywordsRow4" 
                      :key="keyword"
                      class="keyword-btn"
                      @click="selectKeyword(keyword)"
                    >
                      {{ keyword }}
                    </a-button>
                  </div>
                </div>
              </div>
              </div>

              <!-- 对话状态：显示聊天界面 -->
              <div v-else class="chat-state">
                <!-- 对话历史区域 -->
                <div class="ai-conversation-area">
                  <div class="conversation-list">
                    <div 
                      v-for="conversation in conversationHistory" 
                      :key="conversation.id"
                      class="conversation-item"
                      :class="{ 'user-message': conversation.type === 'user', 'ai-message': conversation.type === 'assistant' }"
                    >
                      <div class="conversation-avatar">
                        <UserOutlined v-if="conversation.type === 'user'" />
                        <div v-else class="asknow-robot">
                          <div class="robot-head"></div>
                          <div class="robot-body"></div>
                          <div class="robot-eye left"></div>
                          <div class="robot-eye right"></div>
                        </div>
                      </div>
                      <div class="conversation-content">
                        <div class="conversation-text">
                          {{ conversation.content }}
                          <span v-if="conversation.isStreaming" class="streaming-cursor">|</span>
                        </div>
                        <div class="conversation-time">{{ conversation.time }}</div>
                      </div>
                    </div>
                </div>
                
                <!-- 流式输出中的提示 -->
                <div v-if="isStreaming" class="streaming-indicator">
                  <div class="streaming-avatar">
                    <div class="asknow-robot">
                      <div class="robot-head"></div>
                      <div class="robot-body"></div>
                      <div class="robot-eye left"></div>
                      <div class="robot-eye right"></div>
                    </div>
                  </div>
                  <div class="streaming-content">
                    <div class="streaming-text">Datayesir为您生成答案</div>
                    <div class="streaming-dots">
                      <span></span>
                      <span></span>
                      <span></span>
                    </div>
                  </div>
                  <div class="stop-response-btn">
                    <a-button size="small" @click="stopStreaming">
                      <StopOutlined />
                      停止响应
                    </a-button>
                  </div>
                </div>
                </div>

                <!-- 底部输入区域 -->
                <div class="chat-input-area">
                  <div class="gemini-input-container">
                    <div class="input-content">
                      <a-textarea
                        v-model:value="searchQuery"
                        placeholder=""
                        class="gemini-textarea"
                        @pressEnter="handleSearch"
                        :disabled="isStreaming"
                        :auto-size="{ minRows: 2, maxRows: 6 }"
                      />
                      <a-button 
                        type="primary" 
                        class="send-btn"
                        @click="handleSearch"
                        :disabled="!searchQuery.trim() || isStreaming"
                      >
                        <SendOutlined />
                      </a-button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 右侧浮动服务按钮 -->
    <div class="floating-service">
      <a-button type="primary" class="service-btn">
        <CustomerServiceOutlined />
        线上服务
      </a-button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Header from '@/components/Header.vue'
import {
  RobotOutlined,
  ClockCircleOutlined,
  MessageOutlined,
  BulbOutlined,
  SendOutlined,
  CheckCircleOutlined,
  UserOutlined,
  CustomerServiceOutlined,
  StopOutlined,
  PlusOutlined,
  SettingOutlined,
  AudioOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

// 响应式数据
const searchQuery = ref('')
const searchCategory = ref('all')
const searchHistoryQuery = ref('')
const isDeepThinking = ref(false)
const conversationHistory = ref([])
const isStreaming = ref(false)
const currentStreamingMessage = ref('')
const streamingInterval = ref(null)
const recentConversations = ref([
  { id: 1, title: '你好' },
  { id: 2, title: '企业的简写是什么' }
])

// 8大库关键词内容
const keywordsRow1 = ref([
  '比亚迪的最新财报解读',
  '紫金矿业为什么上涨这么多',
  'PMI',
  '新增招聘公司数量'
])

const keywordsRow2 = ref([
  '动力电池装机量,各类型电池装机量及市场份额',
  '特斯拉最新利好消息,给出具体时间',
  '字节跳动的营业收入'
])

const keywordsRow3 = ref([
  '豆包的下载量和月活数据',
  '中微公司的投资价值分析',
  'Deepseek概念股有哪些',
  '智驾产业链及标的'
])

const keywordsRow4 = ref([
  '比亚迪为什么上涨这么多',
  '人形机器人相关产业链'
])

// 方法
const toggleDeepThinking = () => {
  isDeepThinking.value = !isDeepThinking.value
}

const selectKeyword = (keyword) => {
  searchQuery.value = keyword
  handleSearch()
}

const handleSearch = () => {
  if (!searchQuery.value.trim() || isStreaming.value) return
  
  // 添加用户查询到对话历史
  const userMessage = {
    id: Date.now(),
    type: 'user',
    content: searchQuery.value,
    time: new Date().toLocaleTimeString()
  }
  conversationHistory.value.push(userMessage)
  
  // 开始流式输出
  startStreamingResponse(searchQuery.value, searchCategory.value)
  
  // 清空搜索框
  searchQuery.value = ''
}

const startStreamingResponse = (query, category) => {
  isStreaming.value = true
  currentStreamingMessage.value = ''
  
  // 创建AI消息对象
  const aiMessage = {
    id: Date.now() + 1,
    type: 'assistant',
    content: '',
    time: new Date().toLocaleTimeString(),
    isStreaming: true
  }
  conversationHistory.value.push(aiMessage)
  
  // 模拟流式输出
  const fullResponse = generateAIResponse(query, category)
  const words = fullResponse.split('')
  let currentIndex = 0
  
  const streamInterval = setInterval(() => {
    if (currentIndex < words.length) {
      currentStreamingMessage.value += words[currentIndex]
      // 更新最后一条消息的内容
      const lastMessage = conversationHistory.value[conversationHistory.value.length - 1]
      if (lastMessage && lastMessage.isStreaming) {
        lastMessage.content = currentStreamingMessage.value
      }
      currentIndex++
    } else {
      // 流式输出完成
      clearInterval(streamInterval)
      isStreaming.value = false
      currentStreamingMessage.value = ''
      // 移除流式标记
      const lastMessage = conversationHistory.value[conversationHistory.value.length - 1]
      if (lastMessage) {
        lastMessage.isStreaming = false
      }
    }
  }, 50) // 每50ms输出一个字符
  
  // 保存interval引用以便停止
  streamingInterval.value = streamInterval
}

const stopStreaming = () => {
  if (streamingInterval.value) {
    clearInterval(streamingInterval.value)
    streamingInterval.value = null
  }
  isStreaming.value = false
  currentStreamingMessage.value = ''
  
  // 移除最后一条消息的流式标记
  const lastMessage = conversationHistory.value[conversationHistory.value.length - 1]
  if (lastMessage && lastMessage.isStreaming) {
    lastMessage.isStreaming = false
    lastMessage.content = currentStreamingMessage.value || '响应已停止'
  }
}

const generateAIResponse = (query, category) => {
  // 模拟AI回复逻辑
  const responses = {
    '比亚迪的最新财报解读': '根据比亚迪最新财报数据，公司营收同比增长35.2%，净利润增长28.7%。主要增长动力来自新能源汽车销量的大幅提升，特别是海外市场的突破。建议关注其电池技术和自动驾驶布局。',
    '紫金矿业为什么上涨这么多': '紫金矿业近期上涨主要受益于：1）黄金价格上涨；2）铜价企稳回升；3）公司海外项目进展顺利；4）新能源金属需求增长。建议关注其海外扩张和新能源金属布局。',
    'PMI': '最新PMI数据显示制造业景气度有所回升，新订单指数和产出指数均有所改善。建议关注相关制造业企业的投资机会。',
    '动力电池装机量,各类型电池装机量及市场份额': '根据最新数据，动力电池装机量同比增长45%，其中磷酸铁锂电池占比提升至65%，三元电池占比35%。宁德时代、比亚迪等头部企业市场份额进一步集中。'
  }
  
  return responses[query] || `正在为您搜索"${query}"相关信息，请稍等...`
}

onMounted(() => {
  console.log('AI搜索页面加载完成')
})
</script>

<style lang="scss" scoped>
.ai-search {
  min-height: 100vh;
  background: $bg-secondary;
}

.ai-search-container {
  padding: $spacing-xl 0;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 $spacing-lg;
}

.ai-search-layout {
  display: grid;
  grid-template-columns: 300px 1fr;
  gap: $spacing-xl;
  min-height: 600px;
}

// 左侧AI搜索导航
.ai-sidebar {
  background: $bg-primary;
  border-radius: $border-radius-lg;
  padding: $spacing-lg;
  box-shadow: $box-shadow;
  height: fit-content;
  position: sticky;
  top: 100px;
}

.ai-logo {
  display: flex;
  align-items: center;
  gap: $spacing-md;
  margin-bottom: $spacing-xl;
  
  .ai-icon {
    width: 50px;
    height: 50px;
    background: $bg-gradient;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: $text-white;
    font-size: 24px;
  }
  
  h2 {
    font-size: $font-size-xl;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
  }
}

.search-history {
  margin-bottom: $spacing-lg;
  
  h3 {
    font-size: $font-size-md;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-md;
  }
  
  .history-search {
    margin-bottom: $spacing-md;
  }
  
  .history-list {
    .history-item {
      display: flex;
      align-items: center;
      gap: $spacing-sm;
      padding: $spacing-sm;
      border-radius: $border-radius;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &:hover {
        background: rgba($primary-color, 0.1);
        color: $primary-color;
      }
      
      &.active {
        background: rgba($primary-color, 0.1);
        color: $primary-color;
      }
      
      span {
        font-size: $font-size-sm;
      }
    }
  }
}

.sidebar-footer {
  text-align: center;
  padding-top: $spacing-lg;
  border-top: 1px solid $border-light;
}

// 右侧AI对话区域
.ai-main-content {
  background: $bg-primary;
  border-radius: $border-radius-lg;
  box-shadow: $box-shadow;
  overflow: hidden;
}

.ai-chat-container {
  padding: $spacing-xl;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.welcome-state {
  display: flex;
  flex-direction: column;
  height: 100%;
  justify-content: flex-start;
  align-items: center;
  text-align: center;
  padding-top: $spacing-xl;
  padding-bottom: $spacing-xl;
}

.chat-state {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.ai-chat-header {
  text-align: center;
  margin-bottom: $spacing-lg;
  
  .ai-avatar-large {
    width: 80px;
    height: 80px;
    background: $bg-gradient;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: $text-white;
    font-size: 36px;
    margin: 0 auto $spacing-md;
    
    .asknow-robot {
      position: relative;
      width: 48px;
      height: 48px;
      animation: asknow-pulse 2s infinite;
    }
    
    .robot-head {
      width: 32px;
      height: 24px;
      background: $text-white;
      border-radius: 16px 16px 8px 8px;
      position: absolute;
      top: 4px;
      left: 8px;
    }
    
    .robot-body {
      width: 40px;
      height: 16px;
      background: $text-white;
      border-radius: 8px;
      position: absolute;
      bottom: 4px;
      left: 4px;
    }
    
    .robot-eye {
      width: 6px;
      height: 6px;
      background: $primary-color;
      border-radius: 50%;
      position: absolute;
      top: 10px;
      animation: asknow-blink 3s infinite;
      
      &.left {
        left: 12px;
      }
      
      &.right {
        right: 12px;
      }
    }
  }
  
  h1 {
    font-size: $font-size-xxl;
    font-weight: 600;
    color: $text-primary;
    margin: 0;
  }
}

.ai-search-input {
  margin-bottom: $spacing-lg;
  width: 100%;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

.gemini-input-container {
  background: $bg-primary;
  border: 1px solid $border-color;
  border-radius: 24px;
  padding: 16px;
  box-shadow: $box-shadow;
  
  .input-header {
    margin-bottom: 12px;
    
    .placeholder-text {
      color: $text-secondary;
      font-size: 14px;
      font-weight: 500;
    }
    
    .divider-line {
      height: 1px;
      background: $border-light;
      margin-top: 8px;
    }
  }
  
  .input-content {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    
    .left-tools {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-shrink: 0;
    }
    
    .gemini-textarea {
      flex: 1;
      
      :deep(.ant-input) {
        background: transparent;
        border: none;
        border-radius: 0;
        font-size: 16px;
        color: $text-primary;
        padding: 8px 0;
        min-height: 48px;
        resize: none;
        box-shadow: none;
        
        &::placeholder {
          color: $text-disabled;
        }
        
        &:focus {
          box-shadow: none;
          border: none;
        }
      }
    }
    
    .right-tools {
      display: flex;
      align-items: center;
      gap: 8px;
      flex-shrink: 0;
    }
    
    .tool-btn {
      color: $text-secondary;
      border: none;
      background: transparent;
      padding: 8px;
      border-radius: 8px;
      transition: all 0.2s ease;
      
      &:hover {
        color: $primary-color;
        background: rgba($primary-color, 0.1);
      }
      
      &:focus {
        color: $primary-color;
        background: rgba($primary-color, 0.1);
      }
    }
    
    .send-btn {
      background: $primary-color;
      border-color: $primary-color;
      border-radius: 8px;
      padding: 8px 12px;
      height: auto;
      min-width: 40px;
      
      &:hover {
        background: $primary-light;
        border-color: $primary-light;
      }
      
      &:disabled {
        background: $text-disabled;
        border-color: $text-disabled;
        color: $text-white;
      }
    }
  }
}

.search-actions {
    display: flex;
    align-items: center;
    gap: $spacing-sm;
    
    .deep-thinking-btn {
      color: $text-secondary;
      
      &:hover {
        color: $primary-color;
      }
    }
    
    .search-btn {
      background: $primary-color;
      border-color: $primary-color;
      
      &:hover {
        background: $primary-light;
        border-color: $primary-light;
      }
    }
  }

.keywords-section {
  margin-bottom: $spacing-lg;
  
  h3 {
    font-size: $font-size-lg;
    font-weight: 600;
    color: $text-primary;
    margin-bottom: $spacing-md;
  }
  
  .keywords-grid {
    .keyword-row {
      display: flex;
      flex-wrap: wrap;
      gap: $spacing-sm;
      margin-bottom: $spacing-sm;
      
      .keyword-btn {
        background: $bg-secondary;
        border: 1px solid $border-light;
        color: $text-secondary;
        border-radius: $border-radius;
        font-size: $font-size-sm;
        padding: $spacing-xs $spacing-sm;
        height: auto;
        white-space: nowrap;
        
        &:hover {
          background: rgba($primary-color, 0.1);
          border-color: $primary-color;
          color: $primary-color;
        }
      }
    }
  }
}

.ai-conversation-area {
  flex: 1;
  border: 1px solid $border-light;
  border-radius: $border-radius-lg;
  background: $bg-secondary;
  overflow-y: auto;
  max-height: calc(100vh - 200px);
  min-height: 500px;
}

.chat-input-area {
  position: sticky;
  bottom: 0;
  background: $bg-primary;
  padding: $spacing-md;
  border-top: 1px solid $border-color;
  border-radius: 0 0 $border-radius-lg $border-radius-lg;
  
  .gemini-input-container {
    max-width: 800px;
    margin: 0 auto;
  }
}

.welcome-message {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: $spacing-xl;
  
  .welcome-content {
    text-align: center;
    max-width: 500px;
    
    h3 {
      font-size: $font-size-xl;
      color: $text-primary;
      margin-bottom: $spacing-md;
    }
    
    p {
      font-size: $font-size-md;
      color: $text-secondary;
      line-height: 1.6;
      margin-bottom: $spacing-lg;
    }
    
    .feature-list {
      display: flex;
      flex-direction: column;
      gap: $spacing-sm;
      
      .feature-item {
        display: flex;
        align-items: center;
        gap: $spacing-sm;
        color: $text-secondary;
        
        .anticon {
          color: $success-color;
        }
      }
    }
  }
}

.conversation-list {
  padding: $spacing-lg;
}

.conversation-item {
  display: flex;
  align-items: flex-start;
  gap: $spacing-md;
  margin-bottom: $spacing-lg;
  padding: $spacing-md;
  
  &.user-message {
    flex-direction: row-reverse;
    
    .conversation-content {
      background: $primary-color;
      color: $text-white;
      border-radius: $border-radius-lg $border-radius-lg 4px $border-radius-lg;
    }
    
    .conversation-avatar {
      background: $primary-color;
      color: $text-white;
    }
  }
  
  &.ai-message {
    .conversation-content {
      background: $bg-primary;
      color: $text-primary;
      border-radius: $border-radius-lg $border-radius-lg $border-radius-lg 4px;
      border: 1px solid $border-light;
    }
    
    .conversation-avatar {
      background: $primary-color;
      color: $text-white;
    }
  }
  
  .conversation-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: $font-size-sm;
    flex-shrink: 0;
    
    .asknow-robot {
      position: relative;
      width: 20px;
      height: 20px;
    }
    
    .robot-head {
      width: 12px;
      height: 10px;
      background: $text-white;
      border-radius: 6px 6px 3px 3px;
      position: absolute;
      top: 2px;
      left: 4px;
    }
    
    .robot-body {
      width: 16px;
      height: 6px;
      background: $text-white;
      border-radius: 3px;
      position: absolute;
      bottom: 2px;
      left: 2px;
    }
    
    .robot-eye {
      width: 2px;
      height: 2px;
      background: $primary-color;
      border-radius: 50%;
      position: absolute;
      top: 4px;
      animation: asknow-blink 3s infinite;
      
      &.left {
        left: 5px;
      }
      
      &.right {
        right: 5px;
      }
    }
  }
  
  .conversation-content {
    max-width: 70%;
    padding: $spacing-md;
    box-shadow: $box-shadow;
    
    .conversation-text {
      font-size: $font-size-md;
      line-height: 1.6;
      margin-bottom: $spacing-xs;
    }
    
    .conversation-time {
      font-size: $font-size-xs;
      opacity: 0.7;
      text-align: right;
    }
  }
}

// 右侧浮动服务按钮
.floating-service {
  position: fixed;
  right: $spacing-lg;
  bottom: $spacing-lg;
  z-index: 1000;
  
  .service-btn {
    background: $accent-color;
    border-color: $accent-color;
    border-radius: $border-radius-lg;
    padding: $spacing-sm $spacing-md;
    height: auto;
    box-shadow: $box-shadow-lg;
    
    &:hover {
      background: $accent-light;
      border-color: $accent-light;
      transform: translateY(-2px);
    }
  }
}

@keyframes asknow-pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}

@keyframes asknow-blink {
  0%, 90%, 100% {
    opacity: 1;
  }
  95% {
    opacity: 0;
  }
}

@keyframes streaming-cursor {
  0%, 50% {
    opacity: 1;
  }
  51%, 100% {
    opacity: 0;
  }
}

.streaming-cursor {
  animation: streaming-cursor 1s infinite;
  color: $primary-color;
  font-weight: bold;
}

.streaming-indicator {
  display: flex;
  align-items: flex-start;
  gap: $spacing-md;
  padding: $spacing-md;
  background: rgba($primary-color, 0.05);
  border-radius: $border-radius-lg;
  margin: $spacing-md 0;
  
  .streaming-avatar {
    width: 32px;
    height: 32px;
    background: $primary-color;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    
    .asknow-robot {
      position: relative;
      width: 20px;
      height: 20px;
      animation: asknow-pulse 2s infinite;
    }
    
    .robot-head {
      width: 12px;
      height: 10px;
      background: $text-white;
      border-radius: 6px 6px 3px 3px;
      position: absolute;
      top: 2px;
      left: 4px;
    }
    
    .robot-body {
      width: 16px;
      height: 6px;
      background: $text-white;
      border-radius: 3px;
      position: absolute;
      bottom: 2px;
      left: 2px;
    }
    
    .robot-eye {
      width: 2px;
      height: 2px;
      background: $primary-color;
      border-radius: 50%;
      position: absolute;
      top: 4px;
      animation: asknow-blink 3s infinite;
      
      &.left {
        left: 5px;
      }
      
      &.right {
        right: 5px;
      }
    }
  }
  
  .streaming-content {
    flex: 1;
    
    .streaming-text {
      font-size: $font-size-sm;
      color: $text-secondary;
      margin-bottom: $spacing-xs;
    }
    
    .streaming-dots {
      display: flex;
      gap: 4px;
      
      span {
        width: 6px;
        height: 6px;
        background: $primary-color;
        border-radius: 50%;
        animation: streaming-dots 1.4s infinite ease-in-out both;
        
        &:nth-child(1) {
          animation-delay: -0.32s;
        }
        
        &:nth-child(2) {
          animation-delay: -0.16s;
        }
      }
    }
  }
  
  .stop-response-btn {
    flex-shrink: 0;
  }
}

@keyframes streaming-dots {
  0%, 80%, 100% {
    transform: scale(0);
  }
  40% {
    transform: scale(1);
  }
}

// 响应式设计
@media (max-width: $breakpoint-lg) {
  .ai-search-layout {
    grid-template-columns: 1fr;
    gap: $spacing-lg;
  }
  
  .ai-sidebar {
    position: static;
    order: 2;
  }
  
  .ai-main-content {
    order: 1;
  }
  
  .keywords-grid {
    .keyword-row {
      .keyword-btn {
        font-size: $font-size-xs;
        padding: $spacing-xs;
      }
    }
  }
}

@media (max-width: $breakpoint-md) {
  .ai-chat-container {
    padding: $spacing-lg;
  }
  
  .ai-chat-header {
    .ai-avatar-large {
      width: 60px;
      height: 60px;
      font-size: 28px;
    }
    
    h1 {
      font-size: $font-size-xl;
    }
  }
  
  .floating-service {
    right: $spacing-sm;
    bottom: $spacing-sm;
  }
}
</style>
