import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Category {
  final String id;
  final String name;
  final Map<String, dynamic> details; // other details about the category

  const Category({
    required this.id,
    required this.name,
    required this.details,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) => Category(
    id: doc.id,
    name: doc['name'],
    details: doc['details'],
  );
}

class Expense {
  final String id;
  final String categoryId; // reference to the parent category
  final double amount;
  final String description;
  final Timestamp timestamp;

  const Expense({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.timestamp,
  });

  factory Expense.fromFirestore(DocumentSnapshot doc) => Expense(
    id: doc.id,
    categoryId: doc.reference.parent.id,
    amount: doc['amount'],
    description: doc['description'],
    timestamp: doc['timestamp'],
  );
}
