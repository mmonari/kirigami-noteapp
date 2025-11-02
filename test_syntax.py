#!/usr/bin/env python3
"""
Test Python file for syntax highlighting
"""

import os
import sys

def greet(name: str) -> str:
    """Greet someone by name"""
    return f"Hello, {name}!"

class Calculator:
    """Simple calculator class"""
    
    def __init__(self):
        self.result = 0
    
    def add(self, x, y):
        """Add two numbers"""
        self.result = x + y
        return self.result
    
    def multiply(self, x, y):
        """Multiply two numbers"""
        self.result = x * y
        return self.result

if __name__ == "__main__":
    # Test the greeting function
    print(greet("World"))
    
    # Test the calculator
    calc = Calculator()
    print(f"5 + 3 = {calc.add(5, 3)}")
    print(f"4 * 7 = {calc.multiply(4, 7)}")
