# Arco Design Mobile - Complete Component Reference

## 🎯 Basic Components

### Button 按钮

**Types:** primary, secondary, danger, text, default  
**Sizes:** small (28px), medium (32px), large (40px)  
**States:** default, hover, active, disabled, loading

```dart
ArcoButton(
  label: 'Submit',
  onPressed: handleSubmit,
  type: ArcoButtonType.primary,
  size: ArcoButtonSize.medium,
  loading: false,
  disabled: false,
  icon: Icon(Icons.send),
)
```

**Specs:**
- Border radius: 4px
- Padding: varies by size
- Font: 12-14px, weight 500

---

### Icon 图标

**Sizes:** small (16px), medium (20px), large (24px)

```dart
ArcoIcon(
  icon: Icons.home,
  size: 20,
  color: ArcoColors.textSecondary,
)
```

---

## 📐 Layout Components

### Grid 宫格

```dart
ArcoGrid(
  columnCount: 4,
  children: [
    ArcoGridItem(icon: Icons.star, label: 'Item 1'),
    ArcoGridItem(icon: Icons.star, label: 'Item 2'),
  ],
)
```

**Specs:**
- Default columns: 4
- Item padding: 16px
- Icon size: 28px
- Label: 12px

---

### Sticky 粘性布局

```dart
ArcoSticky(
  offsetTop: 0,
  child: Container(height: 50),
)
```

---

## 📊 Data Display Components

### Avatar 头像

**Shapes:** circle, square  
**Sizes:** small (32px), medium (40px), large (48px)

```dart
ArcoAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  size: 40,
  shape: AvatarShape.circle,
  fallbackIcon: Icons.person,
)
```

---

### Badge 徽标

```dart
ArcoBadge(
  count: 5,
  maxCount: 99,
  child: Icon(Icons.notifications),
)

// Dot badge
ArcoBadge.dot(child: Icon(Icons.mail))
```

**Specs:**
- Min size: 18px
- Font: 11px
- Color: danger red
- Border: 2px white

---

### Tag 标签

**Types:** default, primary, success, warning, danger  
**Sizes:** small, medium

```dart
ArcoTag(
  label: 'New',
  type: TagType.primary,
  closable: true,
  onClose: handleClose,
)
```

**Specs:**
- Border radius: 2px
- Padding: 2px 8px
- Font: 12px

---

### Cell 单元格

```dart
ArcoCell(
  title: 'Title',
  subtitle: 'Subtitle',
  icon: Icons.settings,
  trailing: Icon(Icons.chevron_right),
  onTap: handleTap,
)
```

**Specs:**
- Height: min 56px
- Padding: 16px horizontal
- Divider: 1px #E5E6EB

---

### Steps 步骤条

**Directions:** horizontal, vertical

```dart
ArcoSteps(
  current: 1,
  steps: [
    ArcoStep(title: 'Step 1', description: 'Desc 1'),
    ArcoStep(title: 'Step 2', description: 'Desc 2'),
  ],
)
```

**States:** wait, process, finish, error

---

### Collapse 折叠面板

```dart
ArcoCollapse(
  children: [
    ArcoCollapsePanel(
      header: 'Panel 1',
      content: Text('Content 1'),
    ),
  ],
)
```

---

## 📝 Data Entry Components

### Input 输入框

```dart
ArcoInput(
  controller: controller,
  placeholder: 'Enter text',
  obscureText: false,
  validator: validate,
)
```

**Specs:**
- Height: 32px
- Border: 1px #E5E6EB
- Focus border: #165DFF
- Radius: 4px

---

### Switch 开关

```dart
ArcoSwitch(
  value: isOn,
  onChanged: (value) => setState(() => isOn = value),
  enabled: true,
)
```

**Specs:**
- Size: 28x16px
- Thumb: 12px diameter
- Active color: #165DFF
- Inactive color: #C9CDD4

---

### Checkbox 复选框

```dart
ArcoCheckbox(
  value: isChecked,
  label: 'Option',
  onChanged: (value) => setState(() => isChecked = value),
)

// Group
ArcoCheckboxGroup(
  values: selectedValues,
  options: ['A', 'B', 'C'],
  onChanged: handleChanges,
)
```

**Specs:**
- Size: 16x16px
- Checkmark: 2px stroke
- Active: #165DFF

---

### Radio 单选框

```dart
ArcoRadio(
  value: selectedValue,
  groupValue: groupValue,
  label: 'Option A',
  onChanged: (value) => setState(() => groupValue = value),
)

// Group
ArcoRadioGroup(
  value: groupValue,
  options: ['A', 'B', 'C'],
  onChanged: handleChange,
)
```

---

### Slider 滑动条

```dart
ArcoSlider(
  value: sliderValue,
  min: 0,
  max: 100,
  onChanged: (value) => setState(() => sliderValue = value),
)
```

**Specs:**
- Track height: 2px
- Thumb: 16px diameter
- Active track: #165DFF

---

### Rate 评分

```dart
ArcoRate(
  value: rating,
  count: 5,
  onChanged: (value) => setState(() => rating = value),
)
```

**Specs:**
- Icon size: 20px
- Active color: #F7BA1E
- Inactive color: #E5E6EB

---

### DatePicker 日期选择器

```dart
ArcoDatePicker.show(
  context: context,
  initialDate: DateTime.now(),
  onConfirm: (date) => setState(() => selectedDate = date),
)
```

**Modes:** date, time, datetime

---

## 💬 Feedback Components

### Dialog 对话框

```dart
ArcoDialog.show(
  context: context,
  title: 'Confirm',
  content: 'Are you sure?',
  actions: [
    ArcoDialogAction(
      label: 'Cancel',
      onPressed: () => Navigator.pop(context),
    ),
    ArcoDialogAction(
      label: 'Confirm',
      type: DialogActionType.primary,
      onPressed: handleConfirm,
    ),
  ],
)
```

**Specs:**
- Width: max 320px
- Border radius: 8px
- Padding: 24px
- Overlay: rgba(0,0,0,0.45)

---

### Toast 轻提示

```dart
ArcoToast.show(
  context: context,
  message: 'Success!',
  type: ToastType.success,
  duration: Duration(seconds: 2),
)

// Types: success, error, warning, info, loading
```

**Specs:**
- Background: rgba(0,0,0,0.7)
- Border radius: 8px
- Padding: 12px 16px
- Font: 14px white
- Max width: 200px

---

### Loading 加载

```dart
ArcoLoading(
  size: 24,
  color: ArcoColors.primary,
)

// Full screen
ArcoLoading.fullScreen()
```

---

### Progress 进度条

```dart
ArcoProgress(
  value: 60,
  showLabel: true,
  strokeWidth: 4,
)

// Circle
ArcoProgress.circle(value: 60, size: 100)
```

**Specs:**
- Track color: #E5E6EB
- Progress color: #165DFF
- Height: 4px
- Radius: 2px

---

### Popup 弹出层

```dart
ArcoPopup.show(
  context: context,
  position: PopupPosition.bottom,
  child: Container(height: 300),
)
```

**Positions:** top, bottom, left, right, center

---

### ActionSheet 动作面板

```dart
ArcoActionSheet.show(
  context: context,
  title: 'Select Action',
  actions: [
    ActionSheetAction(label: 'Option 1', onPressed: handleOption1),
    ActionSheetAction(label: 'Option 2', onPressed: handleOption2),
  ],
  cancelLabel: 'Cancel',
)
```

---

## 🧭 Navigation Components

### TabBar 标签栏

```dart
ArcoTabBar(
  tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
  currentIndex: selectedIndex,
  onChanged: (index) => setState(() => selectedIndex = index),
)
```

**Specs:**
- Height: 44px
- Indicator: 2px #165DFF
- Active text: #165DFF
- Inactive text: #4E5969

---

### NavBar 导航栏

```dart
ArcoNavBar(
  title: 'Page Title',
  leftWidget: IconButton(icon: Icon(Icons.arrow_back), onPressed: goBack),
  rightWidget: IconButton(icon: Icon(Icons.more_vert), onPressed: showMenu),
)
```

**Specs:**
- Height: 44px
- Background: white
- Title: 18px, weight 500
- Border bottom: 1px #E5E6EB

---

### Dropdown 下拉菜单

```dart
ArcoDropdown(
  items: ['Option 1', 'Option 2', 'Option 3'],
  selectedItem: selected,
  onSelected: (item) => setState(() => selected = item),
  child: Text('Select'),
)
```

---

## Common Patterns

### Form Validation

```dart
Form(
  key: formKey,
  child: Column(
    children: [
      ArcoInput(
        label: 'Email',
        validator: (value) {
          if (value.isEmpty) return 'Required';
          if (!value.contains('@')) return 'Invalid email';
          return null;
        },
      ),
      ArcoButton(
        label: 'Submit',
        onPressed: () {
          if (formKey.currentState.validate()) {
            // Submit
          }
        },
      ),
    ],
  ),
)
```

### List with Cells

```dart
ListView(
  children: [
    ArcoCell(title: 'Profile', onTap: goToProfile),
    ArcoCell(title: 'Settings', onTap: goToSettings),
    ArcoCell(title: 'Logout', onTap: logout, trailing: null),
  ],
)
```

### Card Layout

```dart
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
    side: BorderSide(color: ArcoColors.border),
  ),
  child: Padding(
    padding: EdgeInsets.all(ArcoSpacing.m),
    child: child,
  ),
)
```
