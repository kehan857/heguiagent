<template>
  <div class="ai-dialog" :class="{ 'ai-dialog--expanded': isExpanded }">
    <!-- AI对话框头部 -->
    <div class="ai-dialog-header">
      <div class="ai-dialog-title" @click="!isExpanded && toggleDialog()" :class="{ 'clickable': !isExpanded }">
        <div class="ai-avatar">
          <div class="asknow-robot">
            <div class="robot-head"></div>
            <div class="robot-body"></div>
            <div class="robot-eye left"></div>
            <div class="robot-eye right"></div>
          </div>
        </div>
        <div class="ai-info">
          <h3>AskNow</h3>
          <p>你好,我是AskNow,你的{{ dialogType === 'enterprise' ? '企业分析' : '研报' }}小助手!</p>
        </div>
        <!-- 收起状态下的展开箭头 -->
        <div v-if="!isExpanded" class="expand-arrow">
          <RightOutlined />
        </div>
      </div>
      <div class="ai-dialog-actions" v-if="isExpanded">
        <a-button 
          type="text" 
          size="small" 
          @click="toggleDialog"
          class="toggle-btn"
          title="收起"
        >
          <LeftOutlined />
        </a-button>
      </div>
    </div>

    <!-- AI对话框内容 -->
    <div v-if="isExpanded" class="ai-dialog-content">

      <!-- 对话历史区域 -->
      <div class="ai-conversation">
        <div v-if="messages.length === 0" class="ai-welcome">
          <div class="welcome-content">
            <h4>欢迎使用AskNow！</h4>
            <p>我可以为你:{{ dialogType === 'enterprise' ? '分析企业信息、输出企业诊断报告、查找相关企业数据等' : '总结研报观点、输出结构化信息、查找相关内容等' }},点击"+加入问答"按钮还可添加多篇{{ dialogType === 'enterprise' ? '企业' : '研报' }}进行批量问答。</p>
            <div class="welcome-actions">
              <a-button 
                type="primary" 
                size="small"
                @click="handleQuickAction"
                class="welcome-action-btn"
              >
                {{ dialogType === 'enterprise' ? '生成企业诊断报告 →' : '总结研报观点 →' }}
              </a-button>
            </div>
          </div>
        </div>
        
        <div v-else class="ai-messages">
          <div 
            v-for="message in messages" 
            :key="message.id"
            class="ai-message"
            :class="{ 'ai-message--user': message.type === 'user', 'ai-message--assistant': message.type === 'assistant' }"
          >
            <div class="message-avatar">
              <UserOutlined v-if="message.type === 'user'" />
              <div v-else class="asknow-robot">
                <div class="robot-head"></div>
                <div class="robot-body"></div>
                <div class="robot-eye left"></div>
                <div class="robot-eye right"></div>
              </div>
            </div>
            <div class="message-content">
              <div class="message-text">{{ message.content }}</div>
              <div class="message-time">{{ message.time }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 输入区域 -->
      <div class="ai-input-area">
        <a-textarea
          v-model:value="inputMessage"
          placeholder="请输入您的问题"
          :rows="2"
          :maxlength="1000"
          class="ai-input"
          @keydown.enter.prevent="handleSendMessage"
        />
        <div class="ai-input-footer">
          <span class="char-count">{{ inputMessage.length }}/1000</span>
          <a-button 
            type="primary" 
            size="small"
            @click="handleSendMessage"
            :disabled="!inputMessage.trim()"
            class="send-btn"
          >
            发送
          </a-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { 
  RobotOutlined, 
  UserOutlined, 
  PlusOutlined, 
  MinusOutlined 
} from '@ant-design/icons-vue'

// Props
const props = defineProps({
  dialogType: {
    type: String,
    default: 'general', // 'general', 'enterprise'
    validator: (value) => ['general', 'enterprise'].includes(value)
  },
  defaultExpanded: {
    type: Boolean,
    default: false
  }
})

// Emits
const emit = defineEmits(['toggle', 'send-message'])

// 响应式数据
const isExpanded = ref(props.defaultExpanded)
const activeTab = ref('new')
const inputMessage = ref('')
const messages = ref([])

// 计算属性
const dialogTitle = computed(() => {
  return props.dialogType === 'enterprise' ? '企业分析助手' : '研报分析助手'
})

// 方法
const toggleDialog = () => {
  isExpanded.value = !isExpanded.value
  emit('toggle', isExpanded.value)
}

const handleQuickAction = () => {
  const quickMessage = props.dialogType === 'enterprise' 
    ? '请生成该企业的诊断报告，包括企业概况、财务状况、竞争优势、风险评估等方面的分析。'
    : '请总结这份研报的主要观点，包括核心结论、投资建议、风险提示等关键信息。'
  
  inputMessage.value = quickMessage
  handleSendMessage()
}

const handleSendMessage = () => {
  if (!inputMessage.value.trim()) return
  
  // 添加用户消息
  const userMessage = {
    id: Date.now(),
    type: 'user',
    content: inputMessage.value,
    time: new Date().toLocaleTimeString()
  }
  messages.value.push(userMessage)
  
  // 模拟AI回复
  setTimeout(() => {
    const aiMessage = {
      id: Date.now() + 1,
      type: 'assistant',
      content: generateAIResponse(inputMessage.value),
      time: new Date().toLocaleTimeString()
    }
    messages.value.push(aiMessage)
  }, 1000)
  
  // 清空输入框
  inputMessage.value = ''
  
  // 触发事件
  emit('send-message', userMessage)
}

const generateAIResponse = (userInput) => {
  // 模拟AI回复逻辑
  if (props.dialogType === 'enterprise') {
    if (userInput.includes('诊断报告') || userInput.includes('分析')) {
      return '基于企业数据，我为您生成以下诊断报告：\n\n1. 企业概况：该企业为新能源电池制造龙头企业，在动力电池领域具有技术领先优势。\n\n2. 财务状况：营收持续增长，盈利能力稳定，现金流状况良好。\n\n3. 竞争优势：技术壁垒高，客户粘性强，产业链布局完善。\n\n4. 风险评估：需关注原材料价格波动、技术迭代风险等。'
    }
    return '我正在分析企业信息，请稍等片刻...'
  } else {
    if (userInput.includes('总结') || userInput.includes('观点')) {
      return '根据研报内容，主要观点如下：\n\n1. 核心结论：行业前景看好，建议重点关注相关标的。\n\n2. 投资建议：维持"买入"评级，目标价上调。\n\n3. 风险提示：需关注政策变化、市场竞争等风险因素。'
    }
    return '我正在分析研报内容，请稍等片刻...'
  }
}
</script>

<style lang="scss" scoped>
.ai-dialog {
  position: fixed;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 400px;
  background: $bg-primary;
  border: 1px solid $border-light;
  border-radius: $border-radius-lg 0 0 $border-radius-lg;
  box-shadow: $box-shadow-lg;
  z-index: 1000;
  transition: all 0.3s ease;
  
  &.ai-dialog--expanded {
    height: 90vh;
    min-height: 800px;
  }
  
  &:not(.ai-dialog--expanded) {
    height: auto;
    width: auto;
    background: transparent;
    border: none;
    box-shadow: none;
    right: 20px;
    top: 50%;
    transform: translateY(-50%);
    
    .ai-dialog-content {
      display: none;
    }
    
    .ai-dialog-header {
      background: transparent;
      border: none;
      border-radius: 0;
      padding: 0;
      height: auto;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .ai-dialog-title {
      flex-direction: column;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      position: relative;
      width: auto;
      height: auto;
      justify-content: center;
      
      .ai-info {
        display: block;
        
        p {
          display: none;
        }
        
        h3 {
          font-size: $font-size-xs;
          margin: 0;
          text-align: center;
          color: $text-primary;
          font-weight: 600;
        }
      }
      
      .ai-avatar {
        width: 40px;
        height: 40px;
        margin: 0;
        background: transparent;
        border: none;
        
        .asknow-robot {
          width: 24px;
          height: 24px;
        }
        
        .robot-head {
          width: 16px;
          height: 12px;
          background: $text-primary;
          top: 2px;
          left: 4px;
        }
        
        .robot-body {
          width: 20px;
          height: 8px;
          background: $text-primary;
          bottom: 2px;
          left: 2px;
        }
        
        .robot-eye {
          width: 3px;
          height: 3px;
          background: $text-white;
          top: 5px;
          
          &.left {
            left: 6px;
          }
          
          &.right {
            right: 6px;
          }
        }
      }
    }
  }
}

.ai-dialog-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: $spacing-md;
  border-bottom: 1px solid $border-light;
  background: $bg-gradient;
  color: $text-white;
  border-radius: $border-radius-lg 0 0 0;
}

.ai-dialog-title {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  flex: 1;
  
  &.clickable {
    transition: all 0.3s ease;
    
    &:hover {
      transform: scale(1.05);
      
      .ai-avatar {
        box-shadow: 0 4px 12px rgba($primary-color, 0.3);
      }
      
      .expand-arrow {
        opacity: 1;
        transform: translateY(-50%) translateX(2px);
      }
    }
    
    &:active {
      transform: scale(0.95);
    }
  }
}

.ai-avatar {
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  
  .asknow-robot {
    position: relative;
    width: 24px;
    height: 24px;
    animation: asknow-pulse 2s infinite;
  }
  
  .robot-head {
    width: 16px;
    height: 12px;
    background: $text-white;
    border-radius: 8px 8px 4px 4px;
    position: absolute;
    top: 2px;
    left: 4px;
  }
  
  .robot-body {
    width: 20px;
    height: 8px;
    background: $text-white;
    border-radius: 4px;
    position: absolute;
    bottom: 2px;
    left: 2px;
  }
  
  .robot-eye {
    width: 3px;
    height: 3px;
    background: $primary-color;
    border-radius: 50%;
    position: absolute;
    top: 5px;
    animation: asknow-blink 3s infinite;
    
    &.left {
      left: 6px;
    }
    
    &.right {
      right: 6px;
    }
  }
}

.ai-info {
  h3 {
    font-size: $font-size-md;
    font-weight: 600;
    margin: 0 0 2px 0;
    color: $text-white;
  }
  
  p {
    font-size: $font-size-xs;
    margin: 0;
    color: rgba(255, 255, 255, 0.8);
    line-height: 1.3;
  }
}

.ai-dialog-actions {
  .toggle-btn {
    color: $text-white;
    background: rgba(0, 0, 0, 0.4);
    border: 1px solid rgba(255, 255, 255, 0.3);
    font-size: 14px;
    min-width: 28px;
    height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    padding: 0;
    font-weight: 600;
    
    &:hover {
      background: rgba(0, 0, 0, 0.6);
      border-color: rgba(255, 255, 255, 0.5);
      color: $text-white;
      transform: scale(1.1);
    }
    
    &:active {
      transform: scale(0.9);
    }
  }
}

.ai-dialog-content {
  display: flex;
  flex-direction: column;
  height: calc(100% - 80px);
  padding: $spacing-md;
}

.welcome-actions {
  margin-top: $spacing-md;
  
  .welcome-action-btn {
    background: $primary-color;
    border-color: $primary-color;
    
    &:hover {
      background: $primary-light;
      border-color: $primary-light;
    }
  }
}

.ai-conversation {
  flex: 1;
  overflow-y: auto;
  margin-bottom: $spacing-md;
  border: 1px solid $border-light;
  border-radius: $border-radius;
  background: $bg-secondary;
}

.ai-welcome {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: $spacing-lg;
  
  .welcome-content {
    text-align: center;
    
    h4 {
      font-size: $font-size-md;
      color: $text-primary;
      margin-bottom: $spacing-sm;
    }
    
    p {
      font-size: $font-size-sm;
      color: $text-secondary;
      margin: 0;
    }
  }
}

.ai-messages {
  padding: $spacing-md;
}

.ai-message {
  display: flex;
  gap: $spacing-sm;
  margin-bottom: $spacing-md;
  
  &.ai-message--user {
    flex-direction: row-reverse;
    
    .message-content {
      background: $primary-color;
      color: $text-white;
    }
  }
  
  &.ai-message--assistant {
    .message-content {
      background: $bg-primary;
      border: 1px solid $border-light;
    }
  }
}

.message-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  flex-shrink: 0;
  
  .ai-message--user & {
    background: $primary-color;
    color: $text-white;
  }
  
  .ai-message--assistant & {
    background: $bg-gradient;
    color: $text-white;
    
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
}

.message-content {
  max-width: 80%;
  padding: $spacing-sm;
  border-radius: $border-radius;
  
  .message-text {
    font-size: $font-size-sm;
    line-height: 1.5;
    margin-bottom: $spacing-xs;
    white-space: pre-wrap;
  }
  
  .message-time {
    font-size: $font-size-xs;
    opacity: 0.7;
  }
}

.ai-input-area {
  .ai-input {
    margin-bottom: $spacing-sm;
    
    :deep(.ant-input) {
      border-radius: $border-radius;
      resize: none;
    }
  }
}

.ai-input-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  
  .char-count {
    font-size: $font-size-xs;
    color: $text-secondary;
  }
  
  .send-btn {
    background: $primary-color;
    border-color: $primary-color;
    color: $text-white;
    font-weight: 600;
    font-size: $font-size-sm;
    min-width: 60px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
    
    &:hover:not(:disabled) {
      background: $primary-light;
      border-color: $primary-light;
      color: $text-white;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.4);
    }
    
    &:disabled {
      background: $text-disabled;
      border-color: $text-disabled;
      color: $text-white;
      opacity: 0.6;
      text-shadow: none;
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

// 响应式设计
@media (max-width: $breakpoint-md) {
  .ai-dialog {
    width: 100%;
    right: 0;
    left: 0;
    border-radius: 0;
    
    &.ai-dialog--expanded {
      height: 70vh;
    }
  }
  
  .ai-dialog-header {
    border-radius: 0;
  }
}
</style>
