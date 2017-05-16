import React, { Component } from 'react';
import Helmet from 'react-helmet';
import {
  FavoriteJobIndexContainer,
} from 'containers';

class FavoriteJobIndexPage extends Component {

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <Helmet title="Favorite" />
        <FavoriteJobIndexContainer />
      </div>
    );
  }
}

export default FavoriteJobIndexPage;
