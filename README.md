# graphql-apollo-c#

Example project using [Hot Chocolate](https://chillicream.com/docs/hotchocolate/) + [Apollo Client](https://github.com/apollographql/apollo-client) + [Create React App](https://github.com/facebook/create-react-app) + [React Router](https://github.com/remix-run/react-router)

# Best setup with VS Code and TypeScript

- [GraphQL Code generator](https://github.com/dotansimha/graphql-code-generator)
  - Used to generate typescript interfaces from queries
- [GraphQL: Language Feature Support](https://marketplace.visualstudio.com/items?itemName=GraphQL.vscode-graphql)
  - .graphqrc.yml should be in root, not client root

# How to run

- `dotnet run` in root to start the backend
- `cd client`
- `npm start` to start the dev environment for the frontend
- `npm run codegen` to automatically regenerate query types

After that you should be able to write GraphQL queries and the type interface should be automatically generated
