require 'test_helper'

class EvaluationTest < ActiveSupport::TestCase
  # So this is the setup function that is called before each test
  def setup
    @evaluation = Evaluation.new(
      # add the same random values for the attributes that are in the sample
      status: 'completed',
      date_completed: '2022-09-21',
      project_id: 1,
      evaluator_id: 1,
      evaluatee_id: 2,
      cooperation_rating: 4.0,
      conceptual_rating: 4.0,
      practical_rating: 4.0,
      work_ethic_rating: 4.0,
      comment: 'Great job!'
    )
  end

  test 'should be valid with all attributes' do
    assert @evaluation.valid?
  end

  test 'should be invalid without status' do
    @evaluation.status = nil
    assert_not @evaluation.valid?
  end

  test 'should be invalid without date_completed' do
    @evaluation.date_completed = nil
    assert_not @evaluation.valid?
  end

  test 'should be invalid without project_id' do
    @evaluation.project_id = nil
    assert_not @evaluation.valid?
  end

  test 'should be invalid without evaluator_id' do
    @evaluation.evaluator_id = nil
    assert_not @evaluation.valid?
  end

  test 'should be invalid without evaluatee_id' do
    @evaluation.evaluatee_id = nil
    assert_not @evaluation.valid?
  end

  test 'should be invalid without cooperation_rating' do
    @evaluation.cooperation_rating = nil
    assert_not @evaluation.valid?
  end

  test 'should be invalid without conceptual_rating' do
    @evaluation.conceptual_rating = nil
    assert_not @evaluation.valid?
  end

  test 'should be invalid without practical_rating' do
    @evaluation.practical_rating = nil
    assert_not @evaluation.valid?
  end

  test 'should be invalid without work_ethic_rating' do
    @evaluation.work_ethic_rating = nil
    assert_not @evaluation.valid?
  end

  # notice no test case for comment because it's not required for validation
end
