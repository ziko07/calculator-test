class Operation
  include Mongoid::Document
  include Mongoid::Timestamps
  OPERATIONS = {
    sum: '+',
    difference: '-',
    multiplication: '*',
    division: '/'
  }

  field :action, type: String
  field :result, type: Float
  field :count, type: Integer, default: 0
  field :input1, type: Float
  field :input2, type: Float

  validates :input1, :input2, :result, :action, :count, presence: true
  validates :input1, :input2, numericality: {
    greater_than: -1,
    less_than: 100
  }

  def self.process(params)
    if params[:input1].present? && params[:input2].present? && params[:operation].present?
      a = params[:input1].to_i.to_f
      b = params[:input2].to_i.to_f
      
      if operation_valid?(a, b, params[:operation])
        execute_operation(a, b, params[:operation])
      end
    end
  end

  def as_json(options = {})
    {
      id: _id.to_s,
      operation: "#{input1.to_i} #{OPERATIONS[action.to_sym]} #{input2.to_i}",
      result: result == result.to_i ? result.round(0) : result.round(4),
      count: count
    }
  end

  private

  def self.operation_valid?(a, b, action)
    return false if a < 0 || a > 99 || b < 0 || b > 99
    return false if b == 0 && action == 'division'
    return false unless OPERATIONS[action.to_sym].present?
    true
  end

  def self.execute_operation(a, b, action)
    result = a.public_send(OPERATIONS[action.to_sym], b)
    operation = search(a, b, action, result)
    unless operation.present?
      operation = Operation.new(operation_obj(a, b, action, result))
    end
    operation.count += 1

    operation if operation.save
  end

  def self.search(a, b, action, result)
    Operation.any_of(
      operation_obj(a, b, action, result),
      operation_obj(b, a, action, result)
    ).first
  end

  def self.operation_obj(a, b, action, result)
    {
      input1: a,
      input2: b,
      action: action,
      result: result
    }
  end
end
