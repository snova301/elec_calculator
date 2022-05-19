import 'package:elec_facility_calc/homePage.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 広告用
import 'calcLogic.dart';

class CalcPage extends ConsumerStatefulWidget {
  const CalcPage({Key? key}) : super(key: key);

  @override
  CalcPageState createState() => CalcPageState();
}

class CalcPageState extends ConsumerState<CalcPage> {
  /// admobの関数定義
  // BannerAd adMyBanner = BannerAd(
  //   adUnitId: 'ca-app-pub-3940256099942544/6300978111', // テスト用
  //   size: AdSize.banner,
  //   request: const AdRequest(),
  //   listener: const BannerAdListener(),
  // )..load();

  @override
  Widget build(BuildContext context) {
    /// 画面情報取得
    final _mediaQueryData = MediaQuery.of(context);
    final _screenWidth = _mediaQueryData.size.width;
    final _blockWidth = _screenWidth / 100 * 20;
    final _listViewPadding = _screenWidth / 20;
    // final screenHeight = _mediaQueryData.size.height;
    // final blockSizeVertical = screenHeight / 100;

    /// 電線管設計用List初期化
    int _conduitMaxNumCable = 10;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            ['ケーブル設計', '電力計算', '電線管設計'][ref.watch(bottomNaviSelectProvider)]),
      ),

      /// bottomNavigationBarで選択されたitemについて
      /// widgetのListから選択し、ListViewを表示する
      body: <Widget>[
        _ListViewCableDesign(context, ref, _listViewPadding, _blockWidth),
        _ListViewElecPower(context, ref, _listViewPadding, _blockWidth),
        _ListViewConduit(
            context, ref, _listViewPadding, _blockWidth, _conduitMaxNumCable),
      ][ref.read(bottomNaviSelectProvider)],

      drawer: DrawerContents(context),

      /// bottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: 'ケーブル設計',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: '電力計算',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel_rounded),
            label: '電線管設計',
          ),
        ],
        currentIndex: ref.read(bottomNaviSelectProvider),
        onTap: (index) {
          ref.read(bottomNaviSelectProvider.state).state = index;
        },
      ),

      /// 電線管設計のときのみケーブル選択のためfloatingActionButtonを設置
      floatingActionButton: ref.watch(bottomNaviSelectProvider) == 2
          ? FloatingActionButton(
              tooltip: 'ケーブル追加',
              child: const Icon(Icons.add),
              onPressed: () {
                if (ref.read(conduitListItemProvider).length <
                    _conduitMaxNumCable) {
                  CalcLogic(ref).conduitCableAddRun();
                }
              },
            )
          : null,

      // 広告用のbottomnavigator
      // bottomNavigationBar: Container(
      //   alignment: Alignment.center,
      //   child: AdWidget(ad: adMyBanner),
      //   width: adMyBanner.size.width.toDouble(),
      //   height: adMyBanner.size.height.toDouble(),
      // ),
      // ),
    );
  }
}

/// ケーブル設計のListView Widget
class _ListViewCableDesign extends ListView {
  _ListViewCableDesign(BuildContext context, WidgetRef ref,
      double _listViewPadding, double _blockWidth)
      : super(
          padding:
              EdgeInsets.fromLTRB(_listViewPadding, 10, _listViewPadding, 10),
          children: <Widget>[
            _SeparateText(context, '計算条件'),
            _PhaseSelectCard(context, ref, cableDesignPhaseProvider),
            _CableDeignSelectCableType(context, ref),
            _InputTextCard(
                ref, '電気容量', 'W', '整数のみ', cableDesignElecOutProvider),
            _InputTextCard(ref, '線間電圧', 'V', '整数のみ', cableDesignVoltProvider),
            _InputTextCard(
                ref, '力率', '%', '1-100%の整数のみ', cableDesignCosFaiProvider),
            _InputTextCard(
                ref, 'ケーブル長', 'm', '整数のみ', cableDesignCableLenProvider),
            _RunElevatedButton(
                context, ref, _blockWidth, cableDesignCosFaiProvider),
            _SeparateText(context, '計算結果'),
            _OutputTextCard(ref, '電流', 'A', cableDesignCurrentProvider),
            _OutputTextCard(ref, ref.watch(cableDesignCableTypeProvider), 'mm2',
                cableDesignCableSizeProvider),
            _OutputTextCard(ref, '電圧降下', 'V', cableDesignVoltDropProvider),
            _OutputTextCard(ref, '電力損失', 'W', cableDesignPowerLossProvider),
          ],
        );
}

/// 電力計算のListView Widget
class _ListViewElecPower extends ListView {
  _ListViewElecPower(BuildContext context, WidgetRef ref,
      double _listViewPadding, double _blockWidth)
      : super(
          padding:
              EdgeInsets.fromLTRB(_listViewPadding, 10, _listViewPadding, 10),
          children: <Widget>[
            _SeparateText(context, '計算条件'),
            _PhaseSelectCard(context, ref, elecPowerPhaseProvider),
            _InputTextCard(ref, '線間電圧', 'V', '整数のみ', elecPowerVoltProvider),
            _InputTextCard(ref, '電流', 'A', '整数のみ', elecPowerCurrentProvider),
            _InputTextCard(
                ref, '力率', '%', '1-100%の整数のみ', elecPowerCosFaiProvider),
            _RunElevatedButton(
                context, ref, _blockWidth, elecPowerCosFaiProvider),
            _SeparateText(context, '計算結果'),
            _OutputTextCard(ref, '皮相電力', 'kVA', elecPowerApparentPowerProvider),
            _OutputTextCard(ref, '有効電力', 'kW', elecPowerActivePowerProvider),
            _OutputTextCard(
                ref, '無効電力', 'kVar', elecPowerReactivePowerProvider),
            _OutputTextCard(ref, 'sinφ', '%', elecPowerSinFaiProvider),
          ],
        );
}

/// 電線管設計のListView Widget
class _ListViewConduit extends Column {
  _ListViewConduit(BuildContext context, WidgetRef ref, double _listViewPadding,
      double _blockWidth, int _maxNum)
      : super(
          children: [
            Text('ケーブルは' + _maxNum.toString() + '本まで設定できます。'),
            Container(
              padding: EdgeInsets.fromLTRB(
                  _listViewPadding, 10, _listViewPadding, 10),
              child: _ConduitConduitTypeCard(context, ref),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    _listViewPadding, 10, _listViewPadding, 10),
                itemCount: ref.watch(conduitListItemProvider).length,
                itemBuilder: (context, _index) {
                  String _cableType =
                      ref.watch(conduitListItemProvider)[_index]['type'];
                  String _cableSize =
                      ref.watch(conduitListItemProvider)[_index]['size'];
                  return _ConduitCableCard(
                      context, ref, _cableType, _cableSize, _index);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _ConduitConduitSizeCard(
                    context, ref, '32', conduitConduitSize32Provider),
                _ConduitConduitSizeCard(
                    context, ref, '48', conduitConduitSize48Provider),
              ],
            ),
          ],
        );
}

/// 計算条件や計算結果の文字表示widget
class _SeparateText extends Align {
  _SeparateText(BuildContext context, String _title)
      : super(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              _title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        );
}

/// 相の選択widget
class _PhaseSelectCard extends Card {
  _PhaseSelectCard(BuildContext context, WidgetRef ref, StateProvider _provider)
      : super(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: const Tooltip(
                  message: '選択してください',
                  child: Text(
                    '電源の相',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(_provider.state).state = '単相';
                      },
                      child: const Text('単相'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            ref.watch(_provider) == '単相' ? null : Colors.grey),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(20)),
                      ),
                    ),
                  ),
                  Container(
                    // padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(_provider.state).state = '三相';
                      },
                      child: const Text('三相'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            ref.watch(_provider) == '三相' ? null : Colors.grey),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(20.0)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
}

/// ケーブル種類選択widget
class _CableDeignSelectCableType extends Card {
  _CableDeignSelectCableType(BuildContext context, WidgetRef ref)
      : super(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: const Tooltip(
                  message: 'ドロップダウンから選択してください',
                  child: Text(
                    'ケーブル種類',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: DropdownButton(
                  value: ref.watch(cableDesignCableTypeProvider),
                  items: <String>['600V CV-2C', '600V CV-3C', '600V CVT', 'IV']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      alignment: AlignmentDirectional.centerStart,
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    ref.read(cableDesignCableTypeProvider.state).state = value!;
                  },
                ),
              ),
            ],
          ),
        );
}

/// 入力用のwidget
class _InputTextCard extends Card {
  _InputTextCard(WidgetRef ref, String _title, String _unit, String _message,
      StateProvider<TextEditingController> _provider)
      : super(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  // padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: Tooltip(
                    message: _message,
                    child: Text(
                      _title,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  )),
              ListTile(
                trailing: Text(
                  _unit,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                title: TextField(
                  controller: ref.watch(_provider),
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
        );
}

/// 実行ボタンのWidget
class _RunElevatedButton extends Container {
  _RunElevatedButton(BuildContext context, WidgetRef ref, double _paddingSize,
      StateProvider<TextEditingController> _provider)
      : super(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(_paddingSize, 0, _paddingSize, 0),
          child: ElevatedButton(
            onPressed: () {
              CalcLogic(ref).isCosFaiCorrect(ref.read(_provider).text)
                  ? CalcLogic(ref).selectButtonRun()
                  : showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return _CosFaiAlertDialog(context, ref);
                      },
                    );
            },
            child: const Text(
              '計算実行',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              padding: MaterialStateProperty.all(const EdgeInsets.all(30.0)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        );
}

/// 結果用のwidget
class _OutputTextCard extends Card {
  _OutputTextCard(WidgetRef ref, String _title, String _unit,
      StateProvider<String> _provider)
      : super(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(
                  _title,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              ListTile(
                trailing: ref.watch(_provider) == '要相談'
                    ? const Text('')
                    : Text(
                        _unit,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                title: Text(ref.watch(_provider), textAlign: TextAlign.right),
              ),
            ],
          ),
        );
}

/// 力率が0-100%の範囲内にない場合、ポップアップ表示で警告
class _CosFaiAlertDialog extends AlertDialog {
  _CosFaiAlertDialog(BuildContext context, WidgetRef ref)
      : super(
          title: const Text('力率数値異常'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('力率は1-100の間で設定してください。'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
}

/// 電線管設計電線管の種類widget
class _ConduitConduitTypeCard extends Card {
  _ConduitConduitTypeCard(BuildContext context, WidgetRef ref)
      : super(
          child: ListTile(
            leading: const Text(
              '電線管の種類',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            title: DropdownButton(
              value: ref.watch(conduitConduitTypeProvider),
              items: <String>['PF管', 'C管(薄鋼)', 'G管(厚鋼)', 'FEP管']
                  .map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    alignment: AlignmentDirectional.centerStart,
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onChanged: (String? _value) {
                CalcLogic(ref).conduitTypeChange(_value);
              },
            ),
          ),
          // ),
        );
}

/// 電線管設計電線管のサイズwidget
class _ConduitConduitSizeCard extends Card {
  _ConduitConduitSizeCard(BuildContext context, WidgetRef ref, String _title,
      StateProvider<String> _provider)
      : super(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                /// FEP管はJISで占有率の規定がないので参考値
                ref.watch(conduitConduitTypeProvider) == 'FEP管'
                    ? Text(
                        '電線管サイズ\n占有率 ' + _title + '%(参考値)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )
                    : Text(
                        '電線管サイズ\n占有率 ' + _title + '%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                Text(
                  ref.watch(_provider),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
}

/// 電線管設計表示widget
class _ConduitCableCard extends Card {
  _ConduitCableCard(BuildContext context, WidgetRef ref, String _type,
      String _size, int _index)
      : super(
          child: ListTile(
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: const Text(
                        'ケーブル種類',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DropdownButton(
                      value: ref
                          .watch(conduitListItemProvider)[_index]['type']
                          .toString(),
                      items: <String>[
                        '600V CV-2C',
                        '600V CV-3C',
                        '600V CVT',
                        'IV'
                      ].map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.centerStart,
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (String? _value) {
                        CalcLogic(ref).conduitCardSelectType(_index, _value);
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: const Text(
                        'ケーブルサイズ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    DropdownButton(
                      value: ref
                          .watch(conduitListItemProvider)[_index]['size']
                          .toString(),
                      items: ref
                          .watch(conduitCableSizeListProvider)[_index]
                          .map<DropdownMenuItem<String>>(
                        (value) {
                          return DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.centerStart,
                            value: value.toString(),
                            child: Text(value.toString()),
                          );
                        },
                      ).toList(),
                      onChanged: (String? _value) {
                        CalcLogic(ref).conduitCardSelectSize(_index, _value);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Text(
                        'mm2',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// アイテム削除ボタン
            trailing: IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                color: Colors.redAccent,
              ),
              onPressed: () {
                CalcLogic(ref).conduitCableRemove(_index);
              },
            ),
          ),
        );
}
