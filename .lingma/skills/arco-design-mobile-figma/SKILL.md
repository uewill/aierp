---
name: arco-design-mobile-figma
description: Complete Arco Design Mobile component library for Flutter. Implements all components from the official Figma design system including buttons, forms, feedback, navigation, data display, and layout components. Use when building mobile UIs with Arco Design specifications or converting Figma designs to Flutter code.
---

# Arco Design Mobile - Complete Flutter Implementation

## Overview

This skill provides complete implementations of **all Arco Design Mobile components** based on the official Figma design system. It covers 40+ components across 6 categories.

## Component Categories

### 🎯 Basic (通用)
- Button 按钮
- Icon 图标

### 📐 Layout (布局)
- Grid 宫格
- Sticky 粘性布局

### 📊 Data Display (数据展示) - 13 components
- Avatar 头像
- Badge 徽标
- Carousel 轮播图
- Cell 单元格
- Collapse 折叠面板
- CountDown 倒计时
- Ellipsis 文本缩略
- Image 图片
- ImagePreview 图片预览
- NoticeBar 通知栏
- Popover 气泡卡片
- Steps 步骤条
- Tag 标签

### 📝 Data Entry (数据输入) - 10 components
- Checkbox 复选框
- DatePicker 日期选择器
- Input 输入框
- InputItem 文本框
- Picker 选择器
- PickerView 选择器视图
- Radio 单选框
- Rate 评分
- Slider 滑动输入条
- Switch 开关
- Textarea 多行文本框

### 💬 Feedback (反馈) - 7 components
- ActionSheet 动作面板
- CircleProgress 环形进度条
- Dialog 对话框
- Notify 消息通知
- Popup 弹出层
- Progress 进度条
- Toast 轻提示

### 🧭 Navigation (导航) - 6 components
- Dropdown 下拉面板
- DropdownMenu 下拉选择菜单
- NavBar 导航栏
- Pagination 分页器
- TabBar 标签栏
- Tabs 选项卡

## Design System Foundation

### Color Tokens

```dart
class ArcoColors {
  // Primary
  static const Color primary = Color(0xFF165DFF);
  static const Color primaryHover = Color(0xFF4080FF);
  static const Color primaryActive = Color(0xFF0E42D2);
  static const Color primaryLight = Color(0xFFE8F3FF);
  
  // Success
  static const Color success = Color(0xFF00B42A);
  static const Color successLight = Color(0xFFE8FFEA);
  
  // Warning
  static const Color warning = Color(0xFFFF7D00);
  static const Color warningLight = Color(0xFFFFF7E8);
  
  // Danger
  static const Color danger = Color(0xFFF53F3F);
  static const Color dangerLight = Color(0xFFFFECE8);
  
  // Neutral
  static const Color textPrimary = Color(0xFF1D2129);
  static const Color textSecondary = Color(0xFF4E5969);
  static const Color textTertiary = Color(0xFF86909C);
  static const Color textPlaceholder = Color(0xFFC9CDD4);
  
  static const Color border = Color(0xFFE5E6EB);
  static const Color borderLight = Color(0xFFF2F3F5);
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
}
```

### Spacing System (8px Grid)

```dart
class ArcoSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
```

### Typography

```dart
class ArcoTypography {
  // Display
  static const TextStyle display1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    height: 1.27,
  );
  
  static const TextStyle display2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.33,
  );
  
  // Title
  static const TextStyle title1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle title2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  
  // Body
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.57,
  );
  
  static const TextStyle body3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.67,
  );
  
  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
  );
}
```

## Quick Start

### 1. Add Theme

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ArcoTheme.lightTheme,
      home: HomePage(),
    );
  }
}
```

### 2. Use Components

```dart
// Button
ArcoButton(
  label: 'Submit',
  onPressed: handleSubmit,
  type: ArcoButtonType.primary,
)

// Input
ArcoInput(
  label: 'Email',
  placeholder: 'Enter email',
  validator: validateEmail,
)

// Switch
ArcoSwitch(
  value: isEnabled,
  onChanged: (value) => setState(() => isEnabled = value),
)

// Dialog
ArcoDialog.show(
  context: context,
  title: 'Confirm',
  content: 'Are you sure?',
  onConfirm: handleConfirm,
)
```

## Implementation Priority

### Phase 1: Core Components (Most Used)
✅ Button, Input, Switch, Checkbox, Radio
✅ Dialog, Toast, Loading
✅ Avatar, Badge, Tag
✅ TabBar, NavBar

### Phase 2: Form Components
⏳ DatePicker, Picker, Slider, Rate
⏳ Textarea, SearchBar

### Phase 3: Feedback & Overlay
⏳ ActionSheet, Popup, Notify
⏳ Progress, CircleProgress

### Phase 4: Data Display
⏳ Cell, Collapse, Steps
⏳ Carousel, Image, NoticeBar
⏳ Popover, Ellipsis, CountDown

### Phase 5: Navigation & Layout
⏳ Dropdown, DropdownMenu, Pagination
⏳ Grid, Sticky

## File Structure

```
lib/
├── arco_design/
│   ├── theme/
│   │   └── arco_theme.dart
│   ├── components/
│   │   ├── basic/
│   │   │   ├── arco_button.dart
│   │   │   └── arco_icon.dart
│   │   ├── form/
│   │   │   ├── arco_input.dart
│   │   │   ├── arco_switch.dart
│   │   │   ├── arco_checkbox.dart
│   │   │   ├── arco_radio.dart
│   │   │   ├── arco_picker.dart
│   │   │   └── arco_date_picker.dart
│   │   ├── feedback/
│   │   │   ├── arco_dialog.dart
│   │   │   ├── arco_toast.dart
│   │   │   ├── arco_loading.dart
│   │   │   └── arco_progress.dart
│   │   ├── display/
│   │   │   ├── arco_avatar.dart
│   │   │   ├── arco_badge.dart
│   │   │   ├── arco_tag.dart
│   │   │   └── arco_cell.dart
│   │   └── navigation/
│   │       ├── arco_tab_bar.dart
│   │       ├── arco_nav_bar.dart
│   │       └── arco_dropdown.dart
│   └── arco_design.dart
```

## Best Practices

### 1. Always Use Design Tokens
```dart
// ✅ Good
color: ArcoColors.primary
padding: EdgeInsets.all(ArcoSpacing.m)

// ❌ Bad
color: Color(0xFF165DFF)
padding: EdgeInsets.all(16)
```

### 2. Implement All States
Every interactive component should handle:
- Default
- Hover/Focus
- Active/Pressed
- Disabled
- Loading
- Error

### 3. Follow 8px Grid
All spacing should be multiples of 4px, preferably 8px.

### 4. Maintain Accessibility
- Minimum touch target: 44x44px
- Color contrast: WCAG AA compliant
- Semantic labels for screen readers

### 5. Performance Optimization
- Use `const` constructors
- Avoid unnecessary rebuilds
- Implement proper list caching
- Lazy load heavy components

## Testing

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ArcoButton displays label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ArcoButton(
          label: 'Click Me',
          onPressed: () {},
        ),
      ),
    );
    
    expect(find.text('Click Me'), findsOneWidget);
  });
}
```

## Additional Resources

- For detailed component specs, see [reference.md](reference.md)
- For usage examples, see [examples.md](examples.md)
- For implementation workflow, see [workflow.md](workflow.md)
- For quick reference, see [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
