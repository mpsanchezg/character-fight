module Utils
  def rand_array(size, max)
    if (size <= max)
      random_numbers = []
      while random_numbers.length < size
        new_number = Random.rand(max) + 1

        if !random_numbers.index(new_number)
          random_numbers.push(new_number)
        end
      end

      random_numbers
    end
  end
end
