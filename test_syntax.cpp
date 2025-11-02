#include <iostream>
#include <string>
#include <vector>

/**
 * Test C++ file for syntax highlighting
 */

// Simple class example
class Person {
private:
    std::string name;
    int age;

public:
    Person(const std::string& n, int a) : name(n), age(a) {}
    
    void introduce() const {
        std::cout << "Hi, I'm " << name 
                  << " and I'm " << age << " years old." << std::endl;
    }
    
    // Getters
    std::string getName() const { return name; }
    int getAge() const { return age; }
};

int main() {
    // Create some people
    std::vector<Person> people = {
        Person("Alice", 25),
        Person("Bob", 30),
        Person("Charlie", 35)
    };
    
    // Introduce everyone
    for (const auto& person : people) {
        person.introduce();
    }
    
    return 0;
}
