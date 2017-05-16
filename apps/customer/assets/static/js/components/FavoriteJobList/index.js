import React from 'react';
import PropTypes from 'prop-types';
import { FavoriteJobFormItem } from 'components';
import { Wrapper, Header, HeaderRow, ContentWrapper } from './styles';
const propTypes = {
  favoriteJobs: PropTypes.array.isRequired,
  handleRemove: PropTypes.func.isRequired,
  handleUpdate: PropTypes.func.isRequired,
};

const FavoriteJobList = ({ favoriteJobs, handleRemove, handleUpdate }) => (
  <Wrapper>
    <ul>
      <Header>
        <HeaderRow size="3">Job Summary</HeaderRow>
        <HeaderRow size="2">Interest</HeaderRow>
        <HeaderRow size="2">Status</HeaderRow>
        <HeaderRow size="2">Remarks</HeaderRow>
        <HeaderRow size="1">Action</HeaderRow>
      </Header>
    </ul>
    {renderFavoriteJobRows(favoriteJobs, handleRemove, handleUpdate)}
  </Wrapper>
  );

function renderFavoriteJobRows(favoriteJobs, remove, update) {
  return favoriteJobs.map((favoriteJob, index) => {
    const property = { ...favoriteJob, index, handleRemove: remove, handleUpdate: update };
    return <FavoriteJobFormItem key={favoriteJob.jobId} {...property} />;
  });
}

FavoriteJobList.propTypes = propTypes;
export default FavoriteJobList;
