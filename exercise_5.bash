cat text.txt

echo "Let's learn Linux." >> text.txt

grep "Love" text.txt

sed -i 's/Make/Do/g' text.txt

awk '{print $3}' text.txt

while IFS= read -r line; do
    echo "Line: $line"
    word_count=$(echo "$line" | wc -w)
    echo "Word count: $word_count"
done < text.txt
