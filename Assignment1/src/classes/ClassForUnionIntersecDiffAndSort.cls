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
    public void AssignmentForPracticeMap() {
        Map<String, List<String>> mapToStoreDepartmentAndListOfEmployees = new Map<String, List<String>>();
        mapToStoreDepartmentAndListOfEmployees.put('Marketing', new List<String>
        {'MarketingEmployee1', 'MarketingEmployee2', 'MarketingEmployee3', 'MarketingEmployee4'});
        mapToStoreDepartmentAndListOfEmployees.put('Sales', new List<String>
        {'SalesEmployee1', 'SalesEmployee2', 'SalesEmployee3', 'SalesEmployee4'});
        mapToStoreDepartmentAndListOfEmployees.put('Finance', new List<String>
        {'FinanceEmployee1', 'FinanceEmployee2', 'FinanceEmployee3', 'FinanceEmployee4'});
    }

    public void AssignmentForPracticeSet() {
        Set<String> setForStoringTheNameOfStudentClassA = new Set<String>
        {'Emma Johnson', 'Liam Carter', 'Sophia Patel', 'Noah Brown', 'Ava Singh'};
        Set<String> setForStoringTheNameOfStudentClassB = new Set<String>
        {'Emma Johnson', 'Lucas Anderson', 'Sophia Patel', 'Olivia Taylor', 'Mason Wilson'};
        unionOfClassAClassB(setForStoringTheNameOfStudentClassA, setForStoringTheNameOfStudentClassB);
        intersectionOfClassAClassB(setForStoringTheNameOfStudentClassA, setForStoringTheNameOfStudentClassB);
        diffOfClassAFromClassB(setForStoringTheNameOfStudentClassA, setForStoringTheNameOfStudentClassB);
        diffOfClassBFromClassA(setForStoringTheNameOfStudentClassA, setForStoringTheNameOfStudentClassB);
    }
    
    public Set<String> unionOfClassAClassB(Set<String> classA, Set<String> classB) {
        Set<String> unionSet = new Set<String>(classA);
        unionSet.addAll(classB);
        return unionSet;
    }

    public Set<String> intersectionOfClassAClassB(Set<String> classA, Set<String> classB) {
        Set<String> intersectionSet = new Set<String>(classA);
        intersectionSet.retainAll(classB);
        return intersectionSet;
    }

    public Set<String> diffOfClassAFromClassB(Set<String> classA, Set<String> classB) {
        Set<String> differenceSet = new Set<String>(classA);
        differenceSet.removeAll(classB);
        return differenceSet;
    }

    public Set<String> diffOfClassBFromClassA(Set<String> classA, Set<String> classB) {
        Set<String> differenceSet2 = new Set<String>(classB);
        differenceSet2.removeAll(classA);
        return differenceSet2;
    }

    public void AssignmentForPracticeList() {
        List<Integer> ListOfInteger = new List<Integer>{56, 78, 31, 55, 99};
        ListOfInteger.sort();
    }
}