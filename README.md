# keyboardphobic

A library with widgets that avoid being covered by the software keyboard.

## Important Caveats

To use the `PaddingAvoider` or `SmartTextField` within a `Scaffold`, you **must** provide `false` as the argument to the scaffold's `resizeToAvoidBottomInset` optional parameter. If you do not do this, the widgets will not avoid the keyboard when it appears. This is unfortunately not something I can do anything about as it is part of how scaffold's interact with the keyboard, as they resize to avoid it if `resizeToAvoidBottomInset` is not provided.

The `PaddingAvoider` or `SmartTextField` will not work well if it is placed within a `Column` where the `mainAxisAlignment` is set to arrange the column's widgets in a relative way, for example `MainAxisAlignment.spacedEvenly`. This is because the padding added by the `PaddingAvoider` will in turn re-adjust the relative spacings in the column. If you want to add spacing in a column that uses a `PaddingAvoider` or `SmartTextField` then use empty `Container`s as spacing boxes.
