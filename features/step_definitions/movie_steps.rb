# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
    #debugger
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  rating_list.split(/[\s,]+/).each do |rating|
    #debugger
    if uncheck == "un"
      steps %{
        When I uncheck "ratings[#{rating}]"
        Then the "ratings[#{rating}]" checkbox should not be checked
      }
    elsif uncheck.nil?
      steps %{
        When I check "ratings[#{rating}]"
        Then the "ratings[#{rating}]" checkbox should be checked
      }
    end
  end

  #debugger
  #assert_equal uncheck,"un" 
end

Then /I should (not )?see the following movies:/ do |nosee, movies_table|
  #debugger
  movies_table.raw.each do |movie|
    if nosee.nil?
      step "I should see \"#{movie[0]}\""
    elsif nosee == "not "
      step "I should not see \"#{movie[0]}\""
    end
  end
end

When /I (un)?check all of the ratings/ do |uncheck|
  all_ratings = Movie.all_ratings.join(', ')
  if uncheck == "un"
    steps %{
      When I uncheck the following ratings: #{all_ratings}
    }
  elsif uncheck.nil?
    steps %{
      When I check the following ratings: #{all_ratings}
    }

  end
end

Then /I should see all the movies/ do
  MoviesDbRows = Movie.all.size
  MoviesPageRows = page.all('a', :text => "More about").size
  #debugger

  MoviesDbRows.should == MoviesPageRows
end

Then /I should see the movies in order by (title|release date)/ do |ordering|
  ordering.sub!(' ', '_')
  selected_ratings = Movie.select(:rating).collect { |v| v.rating }.uniq.sort
  moviesOrderedList = Movie.find_all_by_rating(selected_ratings, :order => ordering).collect \
    { |movie| movie.title } 
  moviesList = page.all('table/tbody/tr').collect{ |title| title.text.split(/\n/).first }

  #debugger
  moviesList.should == moviesOrderedList
end

# page.all outputs all html code in the page
# page.all('table/tbody') output everything in a table (that's in the page)
# page.all('table/tbody/tr') output each row of a table as a array
# EXAMPLE OUTPUT:
#(rdb:1) p page.all('table/tbody/tr')[0].text
#"Aladdin\nG\n1992-11-25 00:00:00 UTC\nMore about Aladdin\n"

