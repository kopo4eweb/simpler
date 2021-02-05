class TestsController < Simpler::Controller

  def index
    @tests = Test.all
  end

  def create
    id = Test.insert(test_params(params))

    redirect_to("/tests/#{id}")
  end

  def new; end

  def show
    get_test
  end

  def edit
    get_test
  end

  def update
    get_test
    @test.update(test_params(params))

    redirect_to("/tests/#{@test.id}")
  end

  def destroy
    get_test
    @test.delete

    redirect_to('/tests', 301)
  end

  private

  def get_test
    @test = Test[params[:id].to_i]
    render plain: "Test not found", status: 404, headers: {'Content-Type' => 'text/plain'} if @test.nil?
  end

  def test_params(params)
    test = params['test']
    { title: test['title'], level: test['level'].to_i }
  end
end
