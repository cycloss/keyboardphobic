# keyboardphobic

A library with widgets that avoid being covered by the software keyboard.

See the example directory for how to the widgets in the library.

## Important Caveats

To use the widgets in this library within a `Scaffold`, you **must** provide `false` as the argument to the scaffold's `resizeToAvoidBottomInset` optional parameter. If you do not do this, the widgets will not avoid the keyboard when it appears. This is unfortunately not something I can do anything about as it is part of how scaffolds interact with the keyboard in Flutter. By default the viewport resizes to avoid the keyboard if `resizeToAvoidBottomInset` is not provided.

The `PaddingAvoider`, `SmartPadTextField` and `SmartPadFormField` will not work well if they are placed within a `Column` where the `mainAxisAlignment` is set to arrange the column's widgets in a relative way, for example `MainAxisAlignment.spacedEvenly`, or if the alignment is `MainAxisAlignment.start`. This is because the padding added by the `PaddingAvoider` will in turn re-adjust the relative spacings in the column. If you want to add spacing in a column that uses a `PaddingAvoider` or `SmartTextField` then use empty `Container`s as spacing boxes. For best results use `MainAxisAlignment.end`.

`SmartScrollFormField` or `SmartScrollTextField` **must** have enough space underneath them in a scroll view to allow them to scroll up without overscrolling. If overscroll occurs you will see them scroll up and then immediately scroll back down with the keyboard retracting as overscroll has occured. An easy way to ensure this never happens is just to add a large empty sized box underneath all the widgets in the scroll view.
