require "test_helper" 

"""
Adding comments for myself to learn and for anyone reading this to understand what's going on in this file. 
This file is a test file for the Evaluation model.

How do you create a unit test for a model?

  First go in the file inside the test/models directory the file should be already created for you.
  Second, write the test case for the model.
    create a method called setup that will be called before each test.
    create a test case for each validation in the model.
    these test cases are straight forward, you just need to set the attribute to nil and check if the model is invalid.
    the message in strings should explain what the test is doing.
    
    So, just make a test for each attribute that is necessary for validation basically.

    to run a test, you can run the command `rails test` in the terminal.
    don't forget to migrate before by doing `rails db:migrate`
    if u get bugs with migrate and test let me know (ahmad) happened to me and i fixed it


    So only thing u need to do is make a unit test, and also add in seeds.rb a model
"""

class EvaluationTest < ActiveSupport::TestCase
  
  # So this is the setup function that is called before each test
  def setup
    @evaluation = Evaluation.new(
      # add the same random values for the attributes that are in the sample
      status: "completed",
      date_completed: "2022-09-21",
      project_id: 1,
      evaluator_id: 1,
      evaluatee_id: 2,
      cooperation_rating: 4.0,
      conceptual_rating: 4.0,
      practical_rating: 4.0,
      work_ethic_rating: 4.0,
      comment: "Great job!"
    )
  end

  test "should be valid with all attributes" do
    assert @evaluation.valid?
  end

  test "should be invalid without status" do
    @evaluation.status = nil
    assert_not @evaluation.valid?
  end

  test "should be invalid without date_completed" do
    @evaluation.date_completed = nil
    assert_not @evaluation.valid?
  end

  test "should be invalid without project_id" do
    @evaluation.project_id = nil
    assert_not @evaluation.valid?
  end

  test "should be invalid without evaluator_id" do
    @evaluation.evaluator_id = nil
    assert_not @evaluation.valid?
  end

  test "should be invalid without evaluatee_id" do
    @evaluation.evaluatee_id = nil
    assert_not @evaluation.valid?
  end

  test "should be invalid without cooperation_rating" do
    @evaluation.cooperation_rating = nil
    assert_not @evaluation.valid?
  end

  test "should be invalid without conceptual_rating" do
    @evaluation.conceptual_rating = nil
    assert_not @evaluation.valid?
  end

  test "should be invalid without practical_rating" do
    @evaluation.practical_rating = nil
    assert_not @evaluation.valid?
  end

  test "should be invalid without work_ethic_rating" do
    @evaluation.work_ethic_rating = nil
    assert_not @evaluation.valid?
  end

  # notice no test case for comment because it's not required for validation

end
