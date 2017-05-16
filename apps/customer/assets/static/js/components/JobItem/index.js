import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router';
import { FavoriteButton, TagList, Title, SubText, CompanyInfo } from 'components';
import { Wrapper, DateTime, JobWrapper, JobInfo, FavoriteButtonWrapper } from './styles';

const propTypes = {
  id: PropTypes.number.isRequired,
  title: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
  updatedAt: PropTypes.string.isRequired,
  techs: PropTypes.array.isRequired,
  favorited: PropTypes.bool,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired,
};


const JobItem = ({ id, title, area, companyName, updatedAt, techs, index, favorited, submitting, handleSwitchFavoriteStatus }) => (
  <Wrapper>
    <JobWrapper>
      <JobInfo>
        <Link to={`/jobs/${id}`} >
          <Title>{title}</Title>
          <CompanyInfo name={companyName} area={area} />
        </Link>
        <TagList tags={techs} />
      </JobInfo>
      {renderFavoriteButton(id, favorited, submitting, index, handleSwitchFavoriteStatus)}
    </JobWrapper>
    <DateTime>{updatedAt}</DateTime>
  </Wrapper>
  );

function renderFavoriteButton(id, favorited, submitting = false, index, fnc) {
  if (favorited === undefined) { return; }
  return (
    <FavoriteButtonWrapper>
      <FavoriteButton
        jobId={id}
        favorited={favorited}
        submitting={submitting}
        index={index}
        handleSwitchFavoriteStatus={fnc}
      />
    </FavoriteButtonWrapper>
  );
}

JobItem.propTypes = propTypes;
export default JobItem;
