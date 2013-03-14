IshikawaPm25::Application.routes.draw do
  root :to => "graph#index"
  get ':month/:day' => 'graph#show'
end
