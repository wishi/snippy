using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSharpDemos
{
	class Program
	{	
		static void Main(string[] args)
		{
      // Using variables
			Random rnd = new Random();
			int num = 0;
			num = num + rnd.Next(10);
			num = num + rnd.Next(10);

			Console.WriteLine("Result: {0}", num);

			// Using immutable values (functional style)
			int num0 = 0;
			int num1 = num0 + rnd.Next(10);
			int num2 = num1 + rnd.Next(10);

			Console.WriteLine("Result: {0}", num);

			// Summing & multiplying numbers in the functional style:
			Console.WriteLine(SumNumbersF(1, 5));
			Console.WriteLine(MulNumbersF(1, 5));

      // General 'aggregation' function
			Console.WriteLine(AggregateNumbers(0, (a, b) => a + b, 1, 5));
			Console.WriteLine(AggregateNumbers(1, (a, b) => a * b, 1, 5));
		}

		static int SumNumbersF(int from, int to)
		{
			if (from > to) 
				return 0;
			else 
				return from + SumNumbersF(from + 1, to);
		}

		static int MulNumbersF(int from, int to)
		{
			if (from > to)
				return 1;
			else
				return from * MulNumbersF(from + 1, to);
		}

    // Using function (delegate 'op') as an argument, we can 
    // 'hide' the difficult recursive behavior of the previous
    // two methods into a single generally useful method
		static int AggregateNumbers(int initial, Func<int, int, int> op, int from, int to)
		{
			if (from > to)
				return initial;
			else
				return op(from, AggregateNumbers(initial, op, from + 1, to));
		}
	}
}
