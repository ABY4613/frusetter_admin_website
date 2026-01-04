# Add-on Food Management Screen - Documentation

## Overview
A comprehensive Add-on Food management screen has been created for the Frusette Admin Operations Dashboard. This screen allows administrators to create, list, update, and delete add-on food items with a beautiful, modern design.

## Features Implemented

### 1. **Navigation Integration**
- Added `addonFood` to the `NavigationItem` enum
- Integrated into the sidebar with a shopping cart icon
- Added to the main layout screen routing

### 2. **Data Model** (`lib/model/addon_food.dart`)
The AddonFood model includes:
- `id`: Unique identifier
- `name`: Food item name
- `description`: Detailed description
- `price`: Price in rupees
- `category`: Category (Beverages, Salads, Proteins, etc.)
- `isAvailable`: Availability status
- `imageUrl`: Optional image URL
- `createdAt` & `updatedAt`: Timestamps

Features:
- JSON serialization/deserialization
- `copyWith` method for updates
- Formatted date display

### 3. **Controller** (`lib/controller/addon_food_controller.dart`)
State management with Provider pattern including:
- `fetchAddonFoods()`: Load all items (currently with mock data)
- `createAddonFood()`: Create new item
- `updateAddonFood()`: Update existing item
- `deleteAddonFood()`: Delete item
- `toggleAvailability()`: Quick toggle availability
- `getByCategory()`: Filter by category
- Category management

**Note**: Currently uses mock data. Replace with actual API calls when ready.

### 4. **Main Screen** (`lib/view/side_bar/screens/addon_food/addon_food_screen.dart`)

#### Header Section
- Breadcrumb navigation
- Page title and description
- "Add New Item" button

#### Statistics Cards
Four beautiful stat cards showing:
- Total Items
- Available Items
- Unavailable Items
- Average Price

Each card has:
- Colored icon with background
- Large number display
- Descriptive label

#### Filters
- Category filter (All, Beverages, Salads, Proteins, etc.)
- Sort options:
  - Newest First
  - Oldest First
  - Price: Low to High
  - Price: High to Low
  - Name: A-Z

#### Food Item Cards
Each card displays:
- **Status Badge**: Available/Unavailable with gradient
- **Category Badge**: Color-coded category
- **Creation Date**: "Added X days ago"
- **Image**: 140x140 with placeholder fallback
- **Name**: Large, bold title
- **Description**: Up to 3 lines with ellipsis
- **Price**: Large rupee amount with "/item" suffix
- **Actions Menu**:
  - Toggle Availability
  - Edit Item
  - Delete Item

#### Empty State
Beautiful empty state with:
- Large icon
- Descriptive text
- "Add First Item" button

### 5. **Create/Edit Dialog** (`lib/view/side_bar/screens/addon_food/widgets/create_addon_food_dialog.dart`)

#### Design Features
- **Gradient Header**: Green gradient with icon
- **Form Fields**:
  - Food Name (required)
  - Description (required, multiline)
  - Price (required, numeric)
  - Category (dropdown)
  - Image URL (optional)
  - Availability Switch

#### Validation
- All required fields validated
- Price must be a valid number
- Clear error messages

#### User Experience
- Loading state during submission
- Success/error notifications
- Smooth animations
- Premium design with icons

## Design Highlights

### Color Scheme
- **Primary Green**: `#8AC53D` - Main actions and active states
- **Blue**: `#3B82F6` - Category badges
- **Green**: `#10B981` - Available status
- **Red**: `#F87171` - Delete actions
- **Amber**: `#FBBF24` - Price indicators

### Typography
- Google Fonts Inter throughout
- Bold titles (32px for page, 24px for cards)
- Clear hierarchy with font weights

### Spacing & Layout
- Consistent 8px grid system
- 20px border radius for cards
- 24px padding for content areas
- Proper use of shadows for depth

### Interactive Elements
- Hover effects on buttons
- Smooth transitions
- Color-coded status indicators
- Icon-based actions

## Mock Data
The controller includes 4 sample items:
1. Fresh Orange Juice (Beverages, ₹120)
2. Greek Salad (Salads, ₹180)
3. Protein Smoothie (Beverages, ₹150, Unavailable)
4. Grilled Chicken Breast (Proteins, ₹250)

## Next Steps - API Integration

When you're ready to integrate with your API, update these methods in `addon_food_controller.dart`:

### 1. Fetch Add-on Foods
```dart
Future<void> fetchAddonFoods() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await http.get(
      Uri.parse('YOUR_API_URL/addon-foods'),
      headers: {'Authorization': 'Bearer YOUR_TOKEN'},
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _addonFoods = (data['items'] as List)
          .map((item) => AddonFood.fromJson(item))
          .toList();
    }
    
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _errorMessage = 'Failed to fetch addon foods: ${e.toString()}';
    _isLoading = false;
    notifyListeners();
  }
}
```

### 2. Create Add-on Food
```dart
Future<bool> createAddonFood(AddonFood addonFood) async {
  try {
    final response = await http.post(
      Uri.parse('YOUR_API_URL/addon-foods'),
      headers: {
        'Authorization': 'Bearer YOUR_TOKEN',
        'Content-Type': 'application/json',
      },
      body: json.encode(addonFood.toJson()),
    );
    
    if (response.statusCode == 201) {
      await fetchAddonFoods(); // Refresh list
      return true;
    }
    return false;
  } catch (e) {
    _errorMessage = 'Failed to create addon food: ${e.toString()}';
    notifyListeners();
    return false;
  }
}
```

### 3. Update Add-on Food
```dart
Future<bool> updateAddonFood(AddonFood addonFood) async {
  try {
    final response = await http.put(
      Uri.parse('YOUR_API_URL/addon-foods/${addonFood.id}'),
      headers: {
        'Authorization': 'Bearer YOUR_TOKEN',
        'Content-Type': 'application/json',
      },
      body: json.encode(addonFood.toJson()),
    );
    
    if (response.statusCode == 200) {
      await fetchAddonFoods(); // Refresh list
      return true;
    }
    return false;
  } catch (e) {
    _errorMessage = 'Failed to update addon food: ${e.toString()}';
    notifyListeners();
    return false;
  }
}
```

### 4. Delete Add-on Food
```dart
Future<bool> deleteAddonFood(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('YOUR_API_URL/addon-foods/$id'),
      headers: {'Authorization': 'Bearer YOUR_TOKEN'},
    );
    
    if (response.statusCode == 200) {
      await fetchAddonFoods(); // Refresh list
      return true;
    }
    return false;
  } catch (e) {
    _errorMessage = 'Failed to delete addon food: ${e.toString()}';
    notifyListeners();
    return false;
  }
}
```

## Files Created/Modified

### New Files
1. `lib/model/addon_food.dart` - Data model
2. `lib/controller/addon_food_controller.dart` - State management
3. `lib/view/side_bar/screens/addon_food/addon_food_screen.dart` - Main screen
4. `lib/view/side_bar/screens/addon_food/widgets/create_addon_food_dialog.dart` - Create/Edit dialog

### Modified Files
1. `lib/core/view_models/navigation_view_model.dart` - Added addonFood enum
2. `lib/view/main_layout_screen.dart` - Added routing for addon food screen
3. `lib/view/side_bar/side_bar_widget.dart` - Added navigation menu item
4. `lib/main.dart` - Registered AddonFoodController provider

## How to Use

1. **Access the Screen**: Click on "Add-on Food" in the sidebar
2. **View Items**: See all add-on food items with statistics
3. **Filter**: Use category and sort filters to find specific items
4. **Add New Item**: Click "Add New Item" button and fill in the form
5. **Edit Item**: Click the three-dot menu on any card and select "Edit Item"
6. **Toggle Availability**: Use the menu to quickly mark items as available/unavailable
7. **Delete Item**: Click delete from the menu (with confirmation dialog)

## Design Philosophy

The design follows modern web dashboard best practices:
- **Clean & Minimal**: White background with strategic use of color
- **Information Hierarchy**: Clear visual hierarchy with typography
- **Actionable**: Easy-to-find actions with clear labels
- **Responsive**: Adapts to different screen sizes
- **Consistent**: Matches the existing Frusette Admin design system
- **Professional**: Premium look and feel with attention to detail

## Testing Checklist

- [x] Navigation to Add-on Food screen works
- [x] Statistics cards display correctly
- [x] Filter by category works
- [x] Sort options work
- [x] Create new item dialog opens
- [x] Form validation works
- [x] Edit item dialog pre-fills data
- [x] Toggle availability works
- [x] Delete confirmation works
- [x] Empty state displays when no items
- [x] Mock data loads correctly

## Ready for API Integration

The screen is fully functional with mock data and ready for API integration. Simply replace the TODO comments in the controller methods with your actual API calls, and the entire screen will work seamlessly with your backend.
