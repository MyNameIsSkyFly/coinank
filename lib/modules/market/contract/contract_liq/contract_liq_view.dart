import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_liq_logic.dart';

class ContractLiqPage extends StatefulWidget {
  const ContractLiqPage({super.key});

  @override
  State<ContractLiqPage> createState() => _ContractLiqPageState();
}

class _ContractLiqPageState extends State<ContractLiqPage> {
  final logic = Get.put(ContractLiqLogic());

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
