import fetch from 'node-fetch';
import {
  GraphQLID,
  GraphQLList,
  GraphQLNonNull,
  GraphQLObjectType,
  GraphQLSchema,
  GraphQLString,
} from 'graphql';

const BASE_URL = 'http://localhost:8000';

function getJSONFromRelativeURL(relativeURL) {
  return fetch(`${BASE_URL}${relativeURL}`)
    .then(res => res.json());
}

function getPeople() {
  return getJSONFromRelativeURL('/people/')
    .then(json => json.people);
}

function getPerson(id) {
  return getPersonByURL(`/people/${id}/`);
}

function getPersonByURL(relativeURL) {
  return getJSONFromRelativeURL(relativeURL)
    .then(json => json.person);
}

const PersonType = new GraphQLObjectType({
  name: 'Person',
  description: 'Somebody that you used to know',
  fields: () => ({
    id: {type: GraphQLID},
    firstName: {
      type: GraphQLString,
      description: 'What you yell at me',
      resolve: obj => obj.first_name,
    },
    lastName: {
      type: GraphQLString,
      description: 'What you yell at me when I\'ve been bad',
      resolve: obj => obj.last_name,
    },
    fullName: {
      type: GraphQLString,
      description: 'A name sandwich',
      resolve: obj => `${obj.first_name} ${obj.last_name}`,
    },
    email: {
      type: GraphQLString,
      description: 'Where to send junk mail',
    },
    username: {
      type: GraphQLString,
      description: 'Log in as this',
    },
    friends: {
      type: new GraphQLList(PersonType),
      description: 'People who lent you money',
      resolve: obj => obj.friends.map(getPersonByURL),
    },
  }),
});

const QueryType = new GraphQLObjectType({
  name: 'Query',
  description: 'The root of all... queries',
  fields: () => ({
    allPeople: {
      type: new GraphQLList(PersonType),
      description: 'Everyone, everywhere',
      resolve: () => getPeople(),
    },
    person: {
      type: PersonType,
      args: {
        id: {type: new GraphQLNonNull(GraphQLID)},
      },
      resolve: (root, args) => getPerson(args.id),
    },
  }),
});

export default new GraphQLSchema({
  query: QueryType,
});
