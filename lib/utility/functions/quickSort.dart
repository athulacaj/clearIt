import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  List<Map> list = [
    {'score': 2},
    {'score': 4},
    {'score': 1},
  ];

  var rng = new Random();

  // for (int i = 0; i < 1000000; i++) {
  //   int r = rng.nextInt(1000);
  //   list.add(r);
  // }
  int high = list.length - 1;
  int low = 0;
  // List<Map> result = quickSort(list, low, high);
  // print(result);
}

List<DocumentSnapshot> quickSort(
    List<DocumentSnapshot<Map>> list, int low, int high) {
  if (low < high) {
    int pi = partition(list, low, high);
    print("pivot: ${list[pi].data()['score']} now at index $pi");

    quickSort(list, low, pi - 1);
    quickSort(list, pi + 1, high);
  }
  return list;
}

int partition(List<DocumentSnapshot<Map>> list, low, high) {
  // Base check
  if (list.isEmpty) {
    return 0;
  }
  // Take our last element as pivot and counter i one less than low
  int pivot = list[high].data()['score'];

  int i = low - 1;
  for (int j = low; j < high; j++) {
    // When j is < than pivot element we increment i and swap arr[i] and arr[j]
    if (list[j].data()['score'] < pivot) {
      i++;
      swap(list, i, j);
    }
  }
  // Swap the last element and place in front of the i'th element
  swap(list, i + 1, high);
  return i + 1;
}

// Swapping using a temp variable
void swap(List<DocumentSnapshot> list, int i, int j) {
  DocumentSnapshot temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

// original
//
// List<int> quickSort(List list, int low, int high) {
//   if (low < high) {
//     int pi = partition(list, low, high);
//     print("pivot: ${list[pi]} now at index $pi");
//
//     quickSort(list, low, pi - 1);
//     quickSort(list, pi + 1, high);
//   }
//   return list;
// }
//
// int partition(List<int> list, low, high) {
//   // Base check
//   if (list.isEmpty) {
//     return 0;
//   }
//   // Take our last element as pivot and counter i one less than low
//   int pivot = list[high];
//
//   int i = low - 1;
//   for (int j = low; j < high; j++) {
//     // When j is < than pivot element we increment i and swap arr[i] and arr[j]
//     if (list[j] < pivot) {
//       i++;
//       swap(list, i, j);
//     }
//   }
//   // Swap the last element and place in front of the i'th element
//   swap(list, i + 1, high);
//   return i + 1;
// }
//
// // Swapping using a temp variable
// void swap(List list, int i, int j) {
//   int temp = list[i];
//   list[i] = list[j];
//   list[j] = temp;
// }
