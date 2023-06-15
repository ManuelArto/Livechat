import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onPress,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: theme.primaryColor.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: endIcon ? theme.iconTheme.color : Colors.red,
            size: 30.0,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge
              ?.apply(color: textColor, fontSizeDelta: 4),
        ),
        trailing: endIcon
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 18.0,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
    );
  }
}
