import 'package:flutter/material.dart';

class StepperControls extends StatelessWidget {
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;

  const StepperControls({Key? key, this.onStepContinue, this.onStepCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color cancelColor;
    final bool isDark;
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        cancelColor = Colors.black54;
        isDark = false;
        break;
      case Brightness.dark:
        cancelColor = Colors.white;
        isDark = true;
        break;
    }

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    const OutlinedBorder buttonShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)));
    const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 48.0),
        child: Row(
          children: <Widget>[
            if (onStepCancel != null)
              Container(
                margin: const EdgeInsetsDirectional.only(end: 8.0),
                child: TextButton(
                  onPressed: onStepCancel,
                  style: TextButton.styleFrom(
                    primary: cancelColor,
                    padding: buttonPadding,
                    shape: buttonShape,
                  ),
                  child: Text(localizations.cancelButtonLabel),
                ),
              ),
            const Expanded(child: SizedBox()),
            if (onStepContinue != null)
              TextButton(
                onPressed: onStepContinue,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : (isDark
                            ? colorScheme.onSurface
                            : colorScheme.onPrimary);
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return isDark || states.contains(MaterialState.disabled)
                        ? null
                        : colorScheme.primary;
                  }),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      buttonPadding),
                  shape: MaterialStateProperty.all<OutlinedBorder>(buttonShape),
                ),
                child: Text(localizations.continueButtonLabel),
              ),
          ],
        ),
      ),
    );
  }
}
