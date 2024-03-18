```markdown
# ToastView

ToastView is a customizable, easy-to-use toast message library for iOS, written in Swift. It allows you to display success, error, or custom messages with optional titles and descriptions.

## Features

- Easy to integrate with just a few lines of code.
- Customizable appearance including background color, text color, and icons.
- Adjustable display duration.
- Supports success and error states with predefined styles.

## Installation

### Manual Installation

To add ToastView to your project manually, download the source code and add the `ToastView.swift` and `ToastViewModel.swift` files to your project directory.

## Usage

First, import `ToastView` at the top of your Swift file:

```swift
import ToastView
```

### Displaying a Success Message

To display a success message, create a `ToastViewModel` for the success state and present the `ToastView`:

```swift
let viewModel = ToastViewModel.successModel(
    title: "Success",
    description: "Everything went well!"
)

let toastView = ToastView(viewModel: viewModel)
toastView.show()
```

### Displaying an Error Message

To display an error message, create a `ToastViewModel` for the error state and present the `ToastView`:

```swift
let viewModel = ToastViewModel.errorModel(
    title: "Error",
    description: "Something went wrong!"
)

let toastView = ToastView(viewModel: viewModel)
toastView.show()
```

### Customizing ToastView

You can customize the `ToastView` by creating a `ToastViewModel` with custom settings:

```swift
let customViewModel = ToastViewModel(
    title: "Notice",
    description: "You have new updates.",
    duration: 3.0,
    icon: UIImage(systemName: "bell"),
    closeIcon: UIImage(systemName: "xmark"),
    backgroundColor: .blue.withAlphaComponent(0.2),
    textColor: .white,
    progressViewColor: .blue,
    iconDimensions: 20
)

let toastView = ToastView(viewModel: customViewModel)
toastView.show()
```

## Requirements

- iOS 13.0+
- Swift 5.3+

## Contribution

Contributions are very welcome 🙌. Feel free to submit a pull request.

## License

ToastView is available under the MIT license. See the LICENSE file for more info.
```

Remember to replace placeholder texts with the actual information where necessary. If you include license information, ensure it matches the license under which you're releasing your library. Also, consider adding a `LICENSE` file to your repository if you haven't done so already.
