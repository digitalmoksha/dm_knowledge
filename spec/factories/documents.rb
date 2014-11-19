FactoryGirl.define do

  factory :document, class: DmKnowledge::Document do
    title                 'Sample Title'
    original_date         '2012-03-19 17:00:00'
    slug                  '2012-03-19-sample-title'
    content               '[:someone:] Some sample content'
    
    factory :invalid_document do
      title               nil
      original_date       nil
    end
  end

end