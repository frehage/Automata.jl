using Base.Test

@testset "Foo Tests" begin
  @testset "Animals" begin
    @test foo("cat") == 9
    @test foo("dog") == foo("cat")
  end
  @testset "Arrays $i" for i in 1:3
    @test foo(zeros(i)) == i^2
    @test foo(ones(i)) == i^2
  end
end
