IshikawaPm25::Application.routes.draw do
  get ':month/:day' => 'graph#show'
end
