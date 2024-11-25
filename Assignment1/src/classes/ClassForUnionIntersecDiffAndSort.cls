/** Purpose : Assignment 1 
Create two sets of strings representing two different groups of students.
Find the union, intersection, and difference of the two sets
Create a map where the keys are strings and the values are lists of strings. 
Add some data representing a department (key) and the list of employees (value) in each department. 
Create a list of integers and add ten random numbers to it. Sort the list in ascending order and print the sorted list.          

Date of create : 25/11/24

Created by : Priyank

Released Log : V1

**/

public class ClassForUnionIntersecDiffAndSort {
    public static void AssignmentForPracticeMap() {
        Map<String, List<String>> mapToStoreDepartmentAndListOfEmployees = new Map<String, List<String>>();
        mapToStoreDepartmentAndListOfEmployees.put('Marketing', new List<String>{'Emma', 'John', 'kia', 'Tia'});
        mapToStoreDepartmentAndListOfEmployees.put('Sales', new List<String>{'Johnson', 'Ana', 'Tic', 'Lana'});
        mapToStoreDepartmentAndListOfEmployees.put('Finance', new List<String>{'Lima', 'Cara', 'Spic', 'Tina'});
    }

    public static void AssignmentForPracticeSet() {
        Set<String> setForStoringTheNameOfStudentClassA = new Set<String>{'Emma', 'Liam Carter', 'Sophia', 'Noah', 'Ava'};
        Set<String> setForStoringTheNameOfStudentClassB = new Set<String>{'Emma', 'Lucas', 'Sophia', 'Olivia', 'Mason'};
        unionOfClassAClassB(setForStoringTheNameOfStudentClassA, setForStoringTheNameOfStudentClassB);
        intersectionOfClassAClassB(setForStoringTheNameOfStudentClassA, setForStoringTheNameOfStudentClassB);
        diffOfClassAFromClassB(setForStoringTheNameOfStudentClassA, setForStoringTheNameOfStudentClassB);
        diffOfClassBFromClassA(setForStoringTheNameOfStudentClassA, setForStoringTheNameOfStudentClassB);
    }
    
    public static Set<String> unionOfClassAClassB(Set<String> classA, Set<String> classB) {
        Set<String> unionSet = new Set<String>(classA);
        unionSet.addAll(classB);
        return unionSet;
    }

    public static Set<String> intersectionOfClassAClassB(Set<String> classA, Set<String> classB) {
        Set<String> intersectionSet = new Set<String>(classA);
        intersectionSet.retainAll(classB);
        return intersectionSet;
    }

    public static Set<String> diffOfClassAFromClassB(Set<String> classA, Set<String> classB) {
        Set<String> differenceSet = new Set<String>(classA);
        differenceSet.removeAll(classB);
        return differenceSet;
    }

    public static Set<String> diffOfClassBFromClassA(Set<String> classA, Set<String> classB) {
        Set<String> differenceSet2 = new Set<String>(classB);
        differenceSet2.removeAll(classA);
        return differenceSet2;
    }

    public static void AssignmentForPracticeList() {
        List<Integer> ListOfInteger = new List<Integer>{56, 78, 31, 55, 99};
        ListOfInteger.sort();
    }
}