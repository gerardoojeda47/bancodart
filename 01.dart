import 'dart:io';

class Customer {
  final String id;
  final String fullName;
  final String email;

  Customer(this.id, this.fullName, this.email);

  String getId() => id;
  String getFullName() => fullName;
  String getEmail() => email;
}

class SavingsAccount {
  final String code;
  final DateTime creationDate;
  double balance;
  final Customer owner;

  SavingsAccount(this.code, this.creationDate, this.balance, this.owner);

  void deposit(double amount) {
    balance += amount;
  }

  bool withdraw(double amount) {
    if (balance >= amount) {
      balance -= amount;
      return true;
    }
    return false;
  }

  String getCode() => code;
  DateTime getCreationDate() => creationDate;
  double getBalance() => balance;
  Customer getOwner() => owner;
}

class Bank {
  final List<SavingsAccount> accounts = [];
  int accountCounter = 0;

  SavingsAccount createAccount(String id, String name, String email) {
    final customer = Customer(id, name, email);
    final year = DateTime.now().year;
    accountCounter++;
    final code = '$year-$accountCounter';
    final account = SavingsAccount(code, DateTime.now(), 0, customer);
    accounts.add(account);
    return account;
  }

  bool deposit(String accountCode, double amount) {
    final account = getAccountByCode(accountCode);
    if (account != null) {
      account.deposit(amount);
      return true;
    }
    return false;
  }

  bool withdraw(String accountCode, double amount) {
    final account = getAccountByCode(accountCode);
    if (account != null) {
      return account.withdraw(amount);
    }
    return false;
  }

  SavingsAccount? getAccountByCode(String accountCode) {
    return accounts.firstWhere((account) => account.getCode() == accountCode,
        // ignore: cast_from_null_always_fails
        orElse: () => null as SavingsAccount);
  }

  List<SavingsAccount> listAccounts() => accounts;
}

void main() {
  final bank = Bank();

  while (true) {
    print('\nMENÚ BANCO ADSO 2874057\n');
    print('1. Crear Cuenta');
    print('2. Consignar Cuenta');
    print('3. Retirar Cuenta');
    print('4. Consultar Cuenta Por Código');
    print('5. Listar Cuentas');
    print('6. Salir');
    stdout.write('Ingrese Opción (1-6): ');

    final option = int.tryParse(stdin.readLineSync() ?? '');

    switch (option) {
      case 1:
        stdout.write('Ingrese identificación: ');
        final id = stdin.readLineSync() ?? '';
        stdout.write('Ingrese nombre completo: ');
        final name = stdin.readLineSync() ?? '';
        stdout.write('Ingrese correo electrónico: ');
        final email = stdin.readLineSync() ?? '';
        final account = bank.createAccount(id, name, email);
        print('Cuenta creada con código: ${account.getCode()}');
        break;

      case 2:
        stdout.write('Ingrese código de cuenta: ');
        final code = stdin.readLineSync() ?? '';
        stdout.write('Ingrese monto a consignar: ');
        final amount = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
        if (bank.deposit(code, amount)) {
          print('Consignación exitosa');
        } else {
          print('Cuenta no encontrada');
        }
        break;

      case 3:
        stdout.write('Ingrese código de cuenta: ');
        final code = stdin.readLineSync() ?? '';
        stdout.write('Ingrese monto a retirar: ');
        final amount = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
        if (bank.withdraw(code, amount)) {
          print('Retiro exitoso');
        } else {
          print('Retiro fallido: fondos insuficientes o cuenta no encontrada');
        }
        break;

      case 4:
        stdout.write('Ingrese código de cuenta: ');
        final code = stdin.readLineSync() ?? '';
        final account = bank.getAccountByCode(code);
        if (account != null) {
          print('Código: ${account.getCode()}');
          print('Fecha de creación: ${account.getCreationDate()}');
          print('Saldo: ${account.getBalance()}');
          print('Propietario: ${account.getOwner().getFullName()}');
        } else {
          print('Cuenta no encontrada');
        }
        break;

      case 5:
        final accounts = bank.listAccounts();
        if (accounts.isEmpty) {
          print('No hay cuentas registradas');
        } else {
          for (final account in accounts) {
            print('Código: ${account.getCode()}, Propietario: ${account.getOwner().getFullName()}, Saldo: ${account.getBalance()}');
          }
        }
        break;

      case 6:
        print('Gracias por usar nuestro sistema. ¡Hasta luego!');
        return;

      default:
        print('Opción inválida. Por favor, intente de nuevo.');
    }
  }
}