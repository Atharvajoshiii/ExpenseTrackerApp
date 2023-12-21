import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
  final FirebaseFirestore firestore;

  ExpenseService({required this.firestore});

  Future<void> deleteExpense(String expenseId) async {
    try {
      await firestore.collection('expenses').doc(expenseId).delete();
      print('Expense deleted successfully');
    } catch (e) {
      print('Error deleting expense: $e');
      throw Exception('Failed to delete expense');
    }
  }
}