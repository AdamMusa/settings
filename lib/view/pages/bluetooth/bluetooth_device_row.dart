import 'package:bluez/bluez.dart';
import 'package:flutter/material.dart';
import 'package:settings/view/widgets/settings_row.dart';

class BluetoothDeviceRow extends StatefulWidget {
  const BluetoothDeviceRow({Key? key, required this.device}) : super(key: key);

  final BlueZDevice device;

  @override
  State<BluetoothDeviceRow> createState() => _BluetoothDeviceRowState();
}

class _BluetoothDeviceRowState extends State<BluetoothDeviceRow> {
  late String status;

  @override
  void initState() {
    status = widget.device.connected ? 'connected' : 'disconnected';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    status = widget.device.connected ? 'connected' : 'disconnected';
    return InkWell(
      borderRadius: BorderRadius.circular(4.0),
      onTap: () => setState(() {
        showSimpleDeviceDialog(context);
      }),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SettingsRow(
            actionLabel: widget.device.name,
            secondChild: Text(
              widget.device.connected ? 'connected' : 'disconnected',
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            )),
      ),
    );
  }

  void showSimpleDeviceDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                  child: Text(widget.device.name),
                ),
                content: SizedBox(
                  height: 270,
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SettingsRow(
                            actionLabel: widget.device.connected
                                ? 'Connected'
                                : 'Disconnected',
                            secondChild: Switch(
                                value: widget.device.connected,
                                onChanged: (newValue) async {
                                  widget.device.connected
                                      ? await widget.device.disconnect()
                                      : await widget.device.connect();
                                  setState(() {});
                                })),
                        SettingsRow(
                            actionLabel:
                                widget.device.paired ? 'Paired' : 'Unpaired',
                            secondChild: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(widget.device.paired ? 'Yes' : 'No'),
                            )),
                        SettingsRow(
                            actionLabel: 'Address',
                            secondChild: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(widget.device.address),
                            )),
                        SettingsRow(
                            actionLabel: 'Type',
                            secondChild: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(widget.device.appearance.toString()),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 8, right: 8, left: 8),
                          child: SizedBox(
                            width: 300,
                            child: OutlinedButton(
                                onPressed: () => print('remove'),
                                child: const Text('Open device settings')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: 300,
                            child: TextButton(
                                onPressed: () => print('remove'),
                                child: const Text('Remove device')),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })).then((value) => setState(() {}));
  }
}
