import 'dart:io';

class User {
  String account;
  String password;
  double balance;
  List<String> transferHistory;

  User(this.account, this.password, {this.balance = 0.0})
      : transferHistory = [];
}

class BankSystem {
  final Map<String, User> users = {};

  void createAccount() {
    stdout.write("输入账户名: ");
    String? account = stdin.readLineSync();
    if (account == null || users.containsKey(account)) {
      print("账户已存在或无效！");
      return;
    }

    stdout.write("输入密码: ");
    String? password = stdin.readLineSync();
    if (password == null || password.isEmpty) {
      print("密码不能为空！");
      return;
    }

    users[account] = User(account, password);
    print("账户创建成功！");
  }

  User? login() {
    stdout.write("输入账户名: ");
    String? account = stdin.readLineSync();
    stdout.write("输入密码: ");
    String? password = stdin.readLineSync();
    
    if (account != null && password != null && users.containsKey(account)) {
      User user = users[account]!;
      if (user.password == password) {
        print("登录成功！");
        return user;
      }
    }
    print("账户或密码错误！");
    return null;
  }

  void checkAllAccounts() {
    if (users.isEmpty) {
      print("当前没有账户。");
      return;
    }
    print("系统账户信息:");
    users.forEach((key, user) {
      print("账户: \$key, 余额: \$${user.balance.toStringAsFixed(2)}");
    });
  }

  void userMenu(User user) {
    while (true) {
      print("\n1. 查询余额  2. 转账  3. 查询转账记录  4. 退出");
      stdout.write("选择操作: ");
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          print("当前余额: \$${user.balance.toStringAsFixed(2)}");
          break;
        case '2':
          transfer(user);
          break;
        case '3':
          print("转账记录:");
          user.transferHistory.forEach(print);
          break;
        case '4':
          return;
        default:
          print("无效选项，请重新选择。");
      }
    }
  }

  void transfer(User sender) {
    stdout.write("输入对方账户: ");
    String? receiverAccount = stdin.readLineSync();
    if (receiverAccount == null || !users.containsKey(receiverAccount)) {
      print("目标账户不存在！");
      return;
    }
    User receiver = users[receiverAccount]!;

    stdout.write("输入转账金额: ");
    double? amount = double.tryParse(stdin.readLineSync() ?? '0');
    if (amount == null || amount <= 0 || amount > sender.balance) {
      print("金额无效或余额不足！");
      return;
    }

    sender.balance -= amount;
    receiver.balance += amount;
    String record = "转账 \$${amount.toStringAsFixed(2)} 到 \$receiverAccount";
    sender.transferHistory.add(record);
    receiver.transferHistory.add("收到 \$${amount.toStringAsFixed(2)} 来自 \$sender.account");

    print("转账成功！");
  }
}

void main() {
  BankSystem bank = BankSystem();
  while (true) {
    print("\n1. 开设账户  2. 登录账户  3. 查询所有账户  4. 退出");
    stdout.write("选择操作: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        bank.createAccount();
        break;
      case '2':
        User? user = bank.login();
        if (user != null) {
          bank.userMenu(user);
        }
        break;
      case '3':
        bank.checkAllAccounts();
        break;
      case '4':
        print("程序退出。");
        return;
      default:
        print("无效选项，请重新选择。");
    }
  }
}
