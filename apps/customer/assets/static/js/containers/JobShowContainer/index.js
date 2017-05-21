import React, { Component } from 'react';
import PropTypes from 'prop-types';

import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobShowActionCreators from './action';
import { FavoriteButton, CompanyInfo } from 'components';

import {
  Wrapper,
  Heading,
  Content,
  Description,
  FavoriteButtonWrapper,
  TitleLink,
} from './styles';

import { TagList, Title, ErrorMessage, RelatedJobList } from 'components';

function mapStateToProps({ jobShow }) {
  const { job, loading, errorMessage } = jobShow;
  return {
    job,
    loading,
    errorMessage,
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      JobShowActionCreators,
      dispatch,
    ),
  };
}

class JobShowContainer extends Component {

  constructor(props) {
    super(props);

    this.handleSwitchFavoriteStatus = this.handleSwitchFavoriteStatus.bind(this);
  }

  componentWillMount() {
    this.props.actions.fetchJob(this.props.id);
  }

  componentWillReceiveProps(newProps) {
    if(newProps.id != this.props.id) {
      this.props.actions.fetchJob(newProps.id);
    }
  }

  handleSwitchFavoriteStatus(_index, jobId, favorited) {
    if (favorited) {
      this.props.actions.favoriteJob(jobId, favorited);
    } else {
      this.props.actions.unfavoriteJob(jobId, favorited);
    }
  }


  renderTechKeywords() {
    const { techKeywords } = this.props.job;
    if (techKeywords.length === 0) return;

    return <TagList tags={techKeywords.map(techKeyword => techKeyword.name)} />;
  }

  renderFavoriteButton() {
    const { id, favorited } = this.props.job;
    if (!favorited) { return; }
    return (
      <FavoriteButtonWrapper>
        <FavoriteButton
          size="large"
          jobId={id}
          favorited={favorited}
          handleSwitchFavoriteStatus={this.handleSwitchFavoriteStatus}
        />
      </FavoriteButtonWrapper>
    );
  }

  renderRelatedJobs() {
    const { relatedJobs } = this.props.job;
    if (relatedJobs.length === 0) return;
    return <RelatedJobList jobs={relatedJobs} />;
  }

  render() {
    const { loading, errorMessage, job } = this.props;
    const { title, company, detail, area, url } = job;

    if (loading) { return (<div />); }

    if (errorMessage) return <ErrorMessage>{errorMessage}</ErrorMessage>;

    return (
      <Wrapper>
        <Heading>
          <TitleLink target="_blank" href={url}>{title}</TitleLink>
          <CompanyInfo name={company.name} area={area} />
          {this.renderTechKeywords()}
          {this.renderFavoriteButton()}
        </Heading>
        <Content>
          <Description dangerouslySetInnerHTML={{ __html: detail }} />
          {this.renderRelatedJobs()}
        </Content>
      </Wrapper>

    );
  }

}

const propTypes = {
  id: PropTypes.string.isRequired,
  job: PropTypes.object,
  errorMessage: PropTypes.string,
  loading: PropTypes.bool.isRequired,
};

JobShowContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobShowContainer);
